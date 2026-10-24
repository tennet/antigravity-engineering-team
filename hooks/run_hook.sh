#!/usr/bin/env bash
# ==============================================================================
# run_hook.sh - macOS & POSIX Fast Polymorphic Python Hook Runner
# DevOps & Infrastructure Sage (v3.0.0)
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

is_safe_binary() {
    local bin="$1"
    [ -x "$bin" ] || return 1

    # Security check: verify binary is not world-writable (avoid privilege escalation / trojan)
    if [ "$(uname -s)" = "Darwin" ]; then
        local perms
        perms="$(stat -f "%Lp" "$bin" 2>/dev/null || echo "")"
        if [ -n "$perms" ] && [ "$(( perms & 002 ))" -ne 0 ]; then
            echo "[SECURITY WARN] Skipping world-writable python binary: $bin" >&2
            return 1
        fi
    fi
    return 0
}

# 1. Check local virtual environments first (.venv or venv)
if [ -f "${PROJECT_ROOT}/.venv/bin/python" ] && is_safe_binary "${PROJECT_ROOT}/.venv/bin/python"; then
    exec "${PROJECT_ROOT}/.venv/bin/python" "$@"
fi

if [ -f "${PROJECT_ROOT}/venv/bin/python" ] && is_safe_binary "${PROJECT_ROOT}/venv/bin/python"; then
    exec "${PROJECT_ROOT}/venv/bin/python" "$@"
fi

# 2. Check python3 in PATH
if command -v python3 >/dev/null 2>&1; then
    exec python3 "$@"
fi

# 3. Check macOS Homebrew Python (Apple Silicon & Intel)
if [ -x "/opt/homebrew/bin/python3" ]; then
    exec "/opt/homebrew/bin/python3" "$@"
fi

if [ -x "/usr/local/bin/python3" ]; then
    exec "/usr/local/bin/python3" "$@"
fi

# 4. Fallback to generic python if Python 3
if command -v python >/dev/null 2>&1; then
    PY_VER="$(python -c 'import sys; print(sys.version_info[0])' 2>/dev/null || echo '0')"
    if [ "$PY_VER" = "3" ]; then
        exec python "$@"
    fi
fi

echo "[ERROR] No suitable Python 3 interpreter found on macOS/POSIX system!" >&2
exit 1
