#!/usr/bin/env python3
"""
Polymorphic Python Resolver for Cross-Platform Hooks (DevOps Sage v3.0.0)
Resolves the optimal Python executable across macOS, Linux, and Windows 11.
Guarantees execution without triggering Windows Store stubs or IDE hangs.
"""

import os
import sys
import subprocess
import shutil

def is_windows_store_dummy(exe_path: str) -> bool:
    """Detect Windows Store dummy execution alias that hangs or prompts."""
    if not exe_path:
        return False
    lower_path = exe_path.lower()
    return "appdata\\local\\microsoft\\windowsapps" in lower_path

def probe_python_executable(candidate: list[str]) -> bool:
    """Quickly verify Python executable candidate without blocking."""
    try:
        res = subprocess.run(
            candidate + ["-c", "import sys; sys.exit(0 if sys.version_info[0] == 3 else 1)"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=2.0,
            check=False
        )
        return res.returncode == 0
    except (subprocess.SubprocessError, FileNotFoundError, PermissionError):
        return False

def discover_python() -> list[str]:
    """
    Polymorphically discover Python 3 in the following priority order:
    1. Active virtual environment (.venv / venv / env in project root)
    2. sys.executable (if already inside a valid Python 3 runtime)
    3. Windows Launcher: py -3 (standard PEP 397)
    4. PATH python3
    5. PATH python (verifying it is not WindowsApps dummy and is Python 3)
    6. Well-known macOS Homebrew / system paths
    """
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    # 1. Virtual Environments in project
    venv_candidates = [
        os.path.join(project_root, ".venv", "bin", "python"),
        os.path.join(project_root, ".venv", "Scripts", "python.exe"),
        os.path.join(project_root, "venv", "bin", "python"),
        os.path.join(project_root, "venv", "Scripts", "python.exe"),
    ]
    for venv_py in venv_candidates:
        if os.path.isfile(venv_py) and os.access(venv_py, os.X_OK):
            if probe_python_executable([venv_py]):
                return [venv_py]

    # 2. Current runtime if Python 3
    if sys.version_info.major == 3 and not is_windows_store_dummy(sys.executable):
        return [sys.executable]

    # 3. Windows PEP 397 Launcher
    if sys.platform == "win32":
        py_launcher = shutil.which("py")
        if py_launcher and probe_python_executable([py_launcher, "-3"]):
            return [py_launcher, "-3"]

    # 4. PATH python3
    py3 = shutil.which("python3")
    if py3 and not is_windows_store_dummy(py3) and probe_python_executable([py3]):
        return [py3]

    # 5. PATH python
    py = shutil.which("python")
    if py and not is_windows_store_dummy(py) and probe_python_executable([py]):
        return [py]

    # 6. macOS Homebrew standard locations
    if sys.platform == "darwin":
        mac_paths = [
            "/opt/homebrew/bin/python3",
            "/usr/local/bin/python3",
            "/usr/bin/python3"
        ]
        for p in mac_paths:
            if os.path.isfile(p) and probe_python_executable([p]):
                return [p]

    raise RuntimeError("No operational Python 3 interpreter found in environment!")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--print-path":
        cmd = discover_python()
        print(" ".join(cmd))
    elif len(sys.argv) > 1:
        # Run passed script with discovered python
        cmd = discover_python() + sys.argv[1:]
        sys.exit(subprocess.call(cmd))
    else:
        cmd = discover_python()
        print(f"Resolved Python: {' '.join(cmd)}")
