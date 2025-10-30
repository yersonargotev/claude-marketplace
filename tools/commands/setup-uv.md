---
description: "Install uv (Astral's fast Python package manager) on macOS, Linux, or Windows"
---

You are installing **uv**, Astral's extremely fast Python package and project manager written in Rust.

## What is uv?

uv is a single tool that replaces pip, pip-tools, pipx, poetry, pyenv, twine, virtualenv, and more - with 10-100x faster performance.

## Installation Process

### Step 1: Detect Operating System

First, determine which platform you're running on by checking the system:

```bash
uname -s
```

### Step 2: Install Based on Platform

#### macOS and Linux

Use the standalone installer script:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Windows

Use PowerShell with the Windows installer:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Step 3: Verify Installation

After installation, verify that uv is available:

```bash
uv --version
```

### Step 4: Update PATH (if needed)

If the command is not found, you may need to add uv to your PATH:

- **macOS/Linux**: Add `~/.cargo/bin` to your PATH
- **Windows**: Add `%USERPROFILE%\.cargo\bin` to your PATH

## Post-Installation

Once installed, you can:

- **Create projects**: `uv init my-project`
- **Add dependencies**: `uv add requests`
- **Run scripts**: `uv run script.py`
- **Install tools**: `uv tool install ruff`
- **Manage Python versions**: `uv python install 3.12`

## Alternative Installation Methods

If you already have pip or pipx:

```bash
# With pip
pip install uv

# Or with pipx
pipx install uv
```

## Self-Update

To update uv to the latest version (if installed via standalone installer):

```bash
uv self update
```

## Documentation

For more information, visit: https://docs.astral.sh/uv

---

## Implementation

Now let me detect your operating system and install uv:
