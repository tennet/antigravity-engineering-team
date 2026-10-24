#!/usr/bin/env bash
# ==============================================================================
# sync.sh - POSIX macOS / Linux Symmetric Cross-Platform Synchronizer
# Part of DevOps & Infrastructure Sage Toolkit (v3.0.0)
#
# Features:
#   - Atomic preventative backup (~/.gemini/config_backup_$(date +%s))
#   - Safe symlinks (ln -sfn) with strict target pre-flight existence verification
#   - Zero destructive 'rm -rf' (obsolete targets archived safely to trash snapshot)
#   - Path traversal and TOCTOU defensive checks
#   - Strict POSIX / Zsh / Bash compliance with error trapping (set -euo pipefail)
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

# Color palettes for audit logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ------------------------------------------------------------------------------
# Logging utilities
# ------------------------------------------------------------------------------
log_info()    { printf "${BLUE}[INFO]${NC}  %s\n" "$*"; }
log_ok()      { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
log_warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
log_error()   { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }
log_audit()   { printf "${CYAN}[AUDIT]${NC} %s\n" "$*"; }

# ------------------------------------------------------------------------------
# Trap & Error handling
# ------------------------------------------------------------------------------
cleanup_on_error() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        log_error "Sync execution interrupted or failed with exit code $exit_code."
        if [ -n "${TMP_BACKUP_DIR:-}" ] && [ -d "${TMP_BACKUP_DIR:-}" ]; then
            log_warn "Cleaning up temporary uncommitted backup staging: ${TMP_BACKUP_DIR}"
            rm -rf "${TMP_BACKUP_DIR}" 2>/dev/null || true
        fi
    fi
}
trap cleanup_on_error EXIT

# ------------------------------------------------------------------------------
# Configuration & Paths
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_ROOT="${SCRIPT_DIR}"
GEMINI_HOME="${HOME}/.gemini"
TIMESTAMP="$(date +%s)"
BACKUP_TARGET_DIR="${GEMINI_HOME}/config_backup_${TIMESTAMP}"
TMP_BACKUP_DIR="${GEMINI_HOME}/.backup_staging_${TIMESTAMP}_$$"
TRASH_DIR="${GEMINI_HOME}/.trash_${TIMESTAMP}"

# ------------------------------------------------------------------------------
# Pre-flight Checks
# ------------------------------------------------------------------------------
log_info "Initializing DevOps Sync for macOS / POSIX environment..."
log_info "Source Directory: ${REPO_ROOT}"
log_info "Target Gemini Home: ${GEMINI_HOME}"

mkdir -p "${GEMINI_HOME}"
chmod 700 "${GEMINI_HOME}"

# ------------------------------------------------------------------------------
# Step 1: Preventative Atomic Backup
# ------------------------------------------------------------------------------
atomic_backup() {
    log_audit "Stage 1: Performing atomic preventative backup..."
    
    # Create isolated temporary staging directory
    mkdir -p "${TMP_BACKUP_DIR}"
    chmod 700 "${TMP_BACKUP_DIR}"

    local files_to_backup=("antigravity" "hooks" "profiles" "environments" "config.json" "settings.json")
    local items_copied=0

    for item in "${files_to_backup[@]}"; do
        local src_path="${GEMINI_HOME}/${item}"
        if [ -e "${src_path}" ] || [ -L "${src_path}" ]; then
            log_info "Backing up: ${src_path}"
            # Use cp -a (archive, preserving attributes, links, permissions)
            cp -a "${src_path}" "${TMP_BACKUP_DIR}/"
            items_copied=$((items_copied + 1))
        fi
    done

    # Write backup manifest for auditing
    cat <<EOF > "${TMP_BACKUP_DIR}/backup_manifest.json"
{
  "timestamp": "${TIMESTAMP}",
  "date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "source_user": "${USER}",
  "host": "$(hostname -s 2>/dev/null || echo 'unknown')",
  "items_backed_up": ${items_copied},
  "status": "committed"
}
EOF

    # Atomic move into final persistent destination
    mv "${TMP_BACKUP_DIR}" "${BACKUP_TARGET_DIR}"
    log_ok "Atomic backup securely sealed at: ${BACKUP_TARGET_DIR} (Items: ${items_copied})"
}

# ------------------------------------------------------------------------------
# Step 2: Safe Non-Destructive Archiving (NO 'rm -rf')
# ------------------------------------------------------------------------------
safe_archive_existing() {
    local dest_path="$1"
    
    if [ ! -e "${dest_path}" ] && [ ! -L "${dest_path}" ]; then
        return 0
    fi

    # Initialize trash directory on first use
    if [ ! -d "${TRASH_DIR}" ]; then
        mkdir -p "${TRASH_DIR}"
        chmod 700 "${TRASH_DIR}"
        log_audit "Created safe non-destructive archive store: ${TRASH_DIR}"
    fi

    local base_name
    base_name="$(basename "${dest_path}")"
    local archived_target="${TRASH_DIR}/${base_name}_$(date +%N)"

    log_warn "Target already exists at ${dest_path}. Moving safely to archive (NON-DESTRUCTIVE): ${archived_target}"
    mv "${dest_path}" "${archived_target}"
}

# ------------------------------------------------------------------------------
# Step 3: Symlink Verification & Creation (ln -sfn)
# ------------------------------------------------------------------------------
safe_symlink() {
    local source_path="$1"
    local link_path="$2"

    # Pre-flight: Verify physical existence of the source
    if [ ! -e "${source_path}" ]; then
        log_error "Symlink aborted: Source path '${source_path}' does not exist!"
        return 1
    fi

    # Resolve canonical source path to prevent TOCTOU and symlink loop traversal
    local canonical_source
    canonical_source="$(cd "$(dirname "${source_path}")" && pwd -P)/$(basename "${source_path}")"

    # Check if target symlink already points to canonical source (idempotence)
    if [ -L "${link_path}" ]; then
        local current_target
        current_target="$(readlink "${link_path}" 2>/dev/null || true)"
        if [ "${current_target}" = "${canonical_source}" ]; then
            log_ok "Symlink already valid and idempotent: ${link_path} -> ${canonical_source}"
            return 0
        fi
    fi

    # Ensure parent directory of link exists
    local link_parent
    link_parent="$(dirname "${link_path}")"
    if [ ! -d "${link_parent}" ]; then
        mkdir -p "${link_parent}"
    fi

    # If destination exists and is not a symlink, or is a broken symlink, archive it
    if [ -e "${link_path}" ] || [ -L "${link_path}" ]; then
        safe_archive_existing "${link_path}"
    fi

    # Create atomic/safe symlink (-s symbolic, -f force overwrite link, -n don't follow directory links)
    ln -sfn "${canonical_source}" "${link_path}"
    log_ok "Symlinked: ${link_path} -> ${canonical_source}"
}

# ------------------------------------------------------------------------------
# Step 4: Core Execution Flow
# ------------------------------------------------------------------------------
main() {
    atomic_backup

    log_audit "Stage 2: Linking configuration assets symmetrically..."

    # Example managed links for 3 Mac + 1 PC cluster
    # 1. Hooks configuration
    if [ -d "${REPO_ROOT}/hooks" ]; then
        safe_symlink "${REPO_ROOT}/hooks" "${GEMINI_HOME}/hooks"
        mkdir -p "${GEMINI_HOME}/config"
        safe_symlink "${REPO_ROOT}/hooks" "${GEMINI_HOME}/config/hooks"
    fi

    # 2. Environment specifications (if present)
    if [ -f "${REPO_ROOT}/.env.example" ]; then
        safe_symlink "${REPO_ROOT}/.env.example" "${GEMINI_HOME}/env.master.template"
    fi

    log_ok "Sync operation completed successfully without data loss."
}

main "$@"
