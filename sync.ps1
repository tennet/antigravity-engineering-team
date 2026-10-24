<#
.SYNOPSIS
    sync.ps1 - Windows 11 Native PowerShell 7+ Symmetric Synchronizer
    Part of DevOps & Infrastructure Sage Toolkit (v3.0.0)

.DESCRIPTION
    Provides automated cross-platform configuration synchronization for Windows 11 workstations.
    - Preventative atomic backup to $HOME\.gemini\config_backup_<timestamp>
    - Native PowerShell 7+ Junctions (New-Item -ItemType Junction) eliminating cmd.exe injection risks
    - Mutex-locked execution eliminating concurrency race conditions
    - Non-destructive unrecoverable delete protection (obsolete targets archived to .trash snapshot)
    - Safe decoupling of Reparse Points without recursing into target
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$TargetDir = "$HOME\.gemini",

    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

# ------------------------------------------------------------------------------
# Console Color Formatting
# ------------------------------------------------------------------------------
function Write-LogInfo    { param([string]$Message) Write-Host "[INFO]  $Message" -ForegroundColor Blue }
function Write-LogOk      { param([string]$Message) Write-Host "[OK]    $Message" -ForegroundColor Green }
function Write-LogWarn    { param([string]$Message) Write-Host "[WARN]  $Message" -ForegroundColor Yellow }
function Write-LogError   { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor Red }
function Write-LogAudit   { param([string]$Message) Write-Host "[AUDIT] $Message" -ForegroundColor Cyan }

# ------------------------------------------------------------------------------
# Inter-Process Mutex Lock (Anti-Concurrency Collision)
# ------------------------------------------------------------------------------
$MutexName = "Global\Antigravity_DevOps_Sync_Lock"
$HasHandle = $false
$SyncMutex = New-Object System.Threading.Mutex($false, $MutexName)

try {
    try {
        $HasHandle = $SyncMutex.WaitOne(5000) # Wait up to 5 seconds for lock
    } catch [System.Threading.AbandonedMutexException] {
        $HasHandle = $true
    }

    if (-not $HasHandle) {
        throw "Another instance of sync.ps1 is currently running. Acquisition timed out."
    }

    # ------------------------------------------------------------------------------
    # Path Normalization & Canonical Resolution
    # ------------------------------------------------------------------------------
    function Resolve-NormalizedPath {
        param ([string]$Path)
        if ([string]::IsNullOrWhiteSpace($Path)) {
            throw "Path cannot be empty or null."
        }
        return [System.IO.Path]::GetFullPath($Path)
    }

    $ScriptDir = Resolve-NormalizedPath -Path $PSScriptRoot
    $RepoRoot = $ScriptDir
    $GeminiHome = Resolve-NormalizedPath -Path $TargetDir
    $Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $ProcessId = $PID

    $BackupTargetDir = Join-Path -Path $GeminiHome -ChildPath "config_backup_$Timestamp"
    $TmpBackupDir    = Join-Path -Path $GeminiHome -ChildPath ".backup_staging_${Timestamp}_${ProcessId}"
    $TrashDir        = Join-Path -Path $GeminiHome -ChildPath ".trash_${Timestamp}_${ProcessId}"

    Write-LogInfo "Initializing DevOps Sync for Windows 11 (PowerShell 7+)..."
    Write-LogInfo "Source Repository: $RepoRoot"
    Write-LogInfo "Gemini Home:       $GeminiHome"

    if (-not (Test-Path -LiteralPath $GeminiHome)) {
        New-Item -ItemType Directory -LiteralPath $GeminiHome -Force | Out-Null
    }

    # ------------------------------------------------------------------------------
    # Step 1: Preventative Atomic Backup
    # ------------------------------------------------------------------------------
    function Invoke-AtomicBackup {
        Write-LogAudit "Stage 1: Performing atomic preventative backup..."

        if (Test-Path -LiteralPath $TmpBackupDir) {
            Remove-Item -LiteralPath $TmpBackupDir -Recurse -Force
        }
        New-Item -ItemType Directory -LiteralPath $TmpBackupDir -Force | Out-Null

        $ItemsToBackup = @("antigravity", "hooks", "profiles", "environments", "config.json", "settings.json")
        $ItemsCount = 0

        foreach ($Item in $ItemsToBackup) {
            $SourceItem = Join-Path -Path $GeminiHome -ChildPath $Item
            if (Test-Path -LiteralPath $SourceItem) {
                Write-LogInfo "Backing up: $SourceItem"
                $DestItem = Join-Path -Path $TmpBackupDir -ChildPath $Item
                Copy-Item -LiteralPath $SourceItem -Destination $DestItem -Recurse -Force
                $ItemsCount++
            }
        }

        $Manifest = @{
            timestamp        = $Timestamp
            date_utc         = [DateTime]::UtcNow.ToString("o")
            operating_system = $PSVersionTable.OS
            ps_version       = $PSVersionTable.PSVersion.ToString()
            user             = $env:USERNAME
            host             = $env:COMPUTERNAME
            process_id       = $ProcessId
            items_backed_up  = $ItemsCount
            status           = "committed"
        } | ConvertTo-Json -Depth 4

        Set-Content -LiteralPath (Join-Path -Path $TmpBackupDir -ChildPath "backup_manifest.json") -Value $Manifest -Encoding utf8

        Move-Item -LiteralPath $TmpBackupDir -Destination $BackupTargetDir -Force
        Write-LogOk "Atomic backup securely sealed at: $BackupTargetDir (Items: $ItemsCount)"
    }

    # ------------------------------------------------------------------------------
    # Step 2: Safe Reparse Point (Junction) Detection & Unlinking
    # ------------------------------------------------------------------------------
    function Remove-SafeJunctionOrPath {
        param ([string]$Path)

        if (-not (Test-Path -LiteralPath $Path)) {
            return
        }

        $Item = Get-Item -LiteralPath $Path -Force
        $IsReparsePoint = [bool]($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)

        if ($IsReparsePoint) {
            Write-LogAudit "Safely decoupling Reparse Point (Junction) without deleting target files: $Path"
            # In .NET/PowerShell, [System.IO.Directory]::Delete removes only the junction reparse point itself!
            if ($Item.PSIsContainer) {
                [System.IO.Directory]::Delete($Path)
            } else {
                [System.IO.File]::Delete($Path)
            }
            return
        }

        # If it is a real physical directory or file, archive it to non-destructive trash snapshot
        if (-not (Test-Path -LiteralPath $TrashDir)) {
            New-Item -ItemType Directory -LiteralPath $TrashDir -Force | Out-Null
        }

        $ArchiveName = "$($Item.Name)_$([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds())"
        $ArchivedDestination = Join-Path -Path $TrashDir -ChildPath $ArchiveName

        Write-LogWarn "Existing real data encountered at $Path. Safely archiving (NON-DESTRUCTIVE) to: $ArchivedDestination"
        Move-Item -LiteralPath $Path -Destination $ArchivedDestination -Force
    }

    # ------------------------------------------------------------------------------
    # Step 3: Pure PowerShell 7+ Junction Creation (Zero cmd.exe / Injection-Proof)
    # ------------------------------------------------------------------------------
    function New-SafeDirectoryJunction {
        param (
            [string]$SourcePath,
            [string]$LinkPath
        )

        $NormalizedSource = Resolve-NormalizedPath -Path $SourcePath
        $NormalizedLink   = Resolve-NormalizedPath -Path $LinkPath

        if (-not (Test-Path -LiteralPath $NormalizedSource)) {
            throw "Target directory '$NormalizedSource' does not exist! Cannot create junction."
        }

        $LinkParent = Split-Path -Path $NormalizedLink -Parent
        if (-not (Test-Path -LiteralPath $LinkParent)) {
            New-Item -ItemType Directory -LiteralPath $LinkParent -Force | Out-Null
        }

        if (Test-Path -LiteralPath $NormalizedLink) {
            $Item = Get-Item -LiteralPath $NormalizedLink -Force
            if ($Item.LinkType -eq "Junction" -and $Item.Target -contains $NormalizedSource) {
                Write-LogOk "Junction already in place and idempotent: $NormalizedLink -> $NormalizedSource"
                return
            }
            Remove-SafeJunctionOrPath -Path $NormalizedLink
        }

        Write-LogAudit "Creating Native Directory Junction: $NormalizedLink -> $NormalizedSource"
        # Pure PowerShell 7+ native cmdlet (No cmd.exe invocation, completely immune to shell injections)
        New-Item -ItemType Junction -Path $NormalizedLink -Target $NormalizedSource -Force | Out-Null

        Write-LogOk "Directory Junction established successfully: $NormalizedLink"
    }

    function New-SafeFileLink {
        param (
            [string]$SourcePath,
            [string]$LinkPath
        )

        $NormalizedSource = Resolve-NormalizedPath -Path $SourcePath
        $NormalizedLink   = Resolve-NormalizedPath -Path $LinkPath

        if (-not (Test-Path -LiteralPath $NormalizedSource)) {
            throw "Target file '$NormalizedSource' does not exist! Cannot link."
        }

        if (Test-Path -LiteralPath $NormalizedLink) {
            Remove-SafeJunctionOrPath -Path $NormalizedLink
        }

        # Try Native PowerShell Hard Link first (same volume)
        try {
            New-Item -ItemType HardLink -Path $NormalizedLink -Target $NormalizedSource -Force -ErrorAction Stop | Out-Null
            Write-LogOk "Native Hard Link created: $NormalizedLink -> $NormalizedSource"
            return
        } catch {
            Write-LogWarn "Cross-volume file detected. Falling back to mirrored copy: $NormalizedLink"
            Copy-Item -LiteralPath $NormalizedSource -Destination $NormalizedLink -Force
        }
    }

    # ------------------------------------------------------------------------------
    # Step 4: Core Execution Flow
    # ------------------------------------------------------------------------------
    Invoke-AtomicBackup

    Write-LogAudit "Stage 2: Linking configuration assets symmetrically on Windows..."

    # Link hooks directory
    $HooksSource = Join-Path -Path $RepoRoot -ChildPath "hooks"
    if (Test-Path -LiteralPath $HooksSource) {
        $HooksLink = Join-Path -Path $GeminiHome -ChildPath "hooks"
        New-SafeDirectoryJunction -SourcePath $HooksSource -LinkPath $HooksLink

        $ConfigDir = Join-Path -Path $GeminiHome -ChildPath "config"
        if (-not (Test-Path -LiteralPath $ConfigDir)) {
            New-Item -ItemType Directory -LiteralPath $ConfigDir -Force | Out-Null
        }
        $ConfigHooksLink = Join-Path -Path $ConfigDir -ChildPath "hooks"
        New-SafeDirectoryJunction -SourcePath $HooksSource -LinkPath $ConfigHooksLink
    }

    # Link env template file
    $EnvSource = Join-Path -Path $RepoRoot -ChildPath ".env.example"
    if (Test-Path -LiteralPath $EnvSource) {
        $EnvLink = Join-Path -Path $GeminiHome -ChildPath "env.master.template"
        New-SafeFileLink -SourcePath $EnvSource -LinkPath $EnvLink
    }

    # 3. Consolidate shared multi-node memory from Google Drive
    $UnifyScript = Join-Path -Path $HooksSource -ChildPath "unify_memory.py"
    if (Test-Path -LiteralPath $UnifyScript) {
        Write-LogAudit "Stage 3: Consolidating multi-node memory from Google Drive..."
        try {
            $RunHook = Join-Path -Path $HooksSource -ChildPath "run_hook.ps1"
            & $RunHook $UnifyScript
        } catch {
            Write-LogWarn "Memory consolidation encountered a non-fatal warning: $_"
        }
    }

    Write-LogOk "Sync operation completed successfully on Windows without privilege elevation."

} finally {
    if ($HasHandle) {
        $SyncMutex.ReleaseMutex()
    }
    $SyncMutex.Dispose()
}
