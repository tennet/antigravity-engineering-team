<#
.SYNOPSIS
    run_hook.ps1 - Native PowerShell 7+ Hook Runner
    DevOps & Infrastructure Sage (v3.0.0)
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ScriptArgs
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptDir "..")

# 1. Virtual Environment
$VenvPy = Join-Path $ProjectRoot ".venv" "Scripts" "python.exe"
if (Test-Path -LiteralPath $VenvPy) {
    & $VenvPy $ScriptArgs
    exit $LASTEXITCODE
}

# 2. PEP 397 py.exe Launcher
$PyCmd = Get-Command -Name "py.exe" -ErrorAction SilentlyContinue
if ($null -ne $PyCmd) {
    & py.exe -3 $ScriptArgs
    exit $LASTEXITCODE
}

# 3. PATH python.exe (excluding WindowsApps store stubs)
$PythonCommands = Get-Command -Name "python.exe" -All -ErrorAction SilentlyContinue
foreach ($cmd in $PythonCommands) {
    if ($cmd.Source -notlike "*WindowsApps*") {
        & $cmd.Source $ScriptArgs
        exit $LASTEXITCODE
    }
}

# 4. PATH python3.exe
$Python3Commands = Get-Command -Name "python3.exe" -All -ErrorAction SilentlyContinue
foreach ($cmd in $Python3Commands) {
    if ($cmd.Source -notlike "*WindowsApps*") {
        & $cmd.Source $ScriptArgs
        exit $LASTEXITCODE
    }
}

Write-Error "No valid Python 3 runtime found on Windows workstation."
exit 1
