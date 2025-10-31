---
description: "Install and configure GitHub CLI (macOS, Linux, Windows)"
---

# GitHub CLI Setup

This command installs and configures GitHub CLI for PR reviews and repository operations.

**Supported Platforms**: macOS, Linux (Ubuntu/Debian), Windows

## What This Command Does

1. **Installs Dependencies** (if missing):

   - Package manager (Homebrew/apt/winget)
   - GitHub CLI (`gh`)

2. **Configures Authentication**:
   - GitHub CLI login with browser-based OAuth

## Prerequisites

- **macOS**: Admin access for installing dependencies
- **Linux**: sudo access (Ubuntu/Debian-based distributions)
- **Windows**: PowerShell 5.1+ or PowerShell 7+ with admin privileges

---

## Step 1: Detect Operating System

First, let me check your platform:

```bash
# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="Linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "$WINDIR" ]]; then
  OS="Windows"
else
  OS="Unknown"
fi

echo "Detected OS: $OS"
```

---

## macOS Installation

### Step 2a: Install Homebrew (macOS)

```bash
if command -v brew >/dev/null 2>&1; then
  echo "✓ Homebrew is already installed ($(brew --version | head -1))"
else
  echo "✗ Homebrew is not installed"
  echo ""
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "✓ Homebrew installed successfully"
fi
```

### Step 3a: Install GitHub CLI (macOS)

```bash
if command -v gh >/dev/null 2>&1; then
  echo "✓ GitHub CLI is already installed ($(gh --version | head -1))"
else
  echo "✗ GitHub CLI is not installed"
  echo "Installing GitHub CLI via Homebrew..."
  brew install gh
  echo "✓ GitHub CLI installed successfully"
fi
```

---

## Linux Installation (Ubuntu/Debian)

### Step 2b: Update Package Manager (Linux)

```bash
echo "Updating apt package manager..."
sudo apt-get update
echo "✓ Package manager updated"
```

### Step 3b: Install GitHub CLI (Linux)

```bash
if command -v gh >/dev/null 2>&1; then
  echo "✓ GitHub CLI is already installed ($(gh --version | head -1))"
else
  echo "✗ GitHub CLI is not installed"
  echo "Installing GitHub CLI..."

  # Install prerequisites
  sudo apt-get install -y curl gnupg

  # Add GitHub CLI repository
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

  # Install GitHub CLI
  sudo apt-get update
  sudo apt-get install -y gh

  echo "✓ GitHub CLI installed successfully"
fi
```

---

## Windows Installation

**Note**: The following commands should be run in **PowerShell as Administrator**.

### Step 2c: Check winget (Windows)

```powershell
# Check if winget is available
if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Host "✓ winget is available" -ForegroundColor Green
} else {
  Write-Host "✗ winget is not available" -ForegroundColor Red
  Write-Host ""
  Write-Host "Installing App Installer (includes winget)..." -ForegroundColor Yellow

  # Download and install App Installer from Microsoft Store
  Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"

  Write-Host "Please install 'App Installer' from the Microsoft Store that just opened."
  Write-Host "After installation, close and reopen PowerShell, then run this setup again."
  exit
}
```

### Step 3c: Install GitHub CLI (Windows)

```powershell
# Check if gh is installed
if (Get-Command gh -ErrorAction SilentlyContinue) {
  $ghVersion = gh --version | Select-String -Pattern "gh version" | Out-String
  Write-Host "✓ GitHub CLI is already installed ($($ghVersion.Trim()))" -ForegroundColor Green
} else {
  Write-Host "✗ GitHub CLI is not installed" -ForegroundColor Red
  Write-Host "Installing GitHub CLI via winget..." -ForegroundColor Yellow

  winget install -e --id GitHub.cli

  Write-Host "✓ GitHub CLI installed successfully" -ForegroundColor Green
  Write-Host "Please close and reopen PowerShell for changes to take effect."
}
```

**Alternative Windows Installation (MSI Installer)**:

If winget is not available, you can install manually:

```powershell
# GitHub CLI MSI
Write-Host "Downloading GitHub CLI installer..."
$ghUrl = "https://github.com/cli/cli/releases/latest/download/gh_windows_amd64.msi"
$ghInstaller = "$env:TEMP\gh_installer.msi"
Invoke-WebRequest -Uri $ghUrl -OutFile $ghInstaller
Start-Process msiexec.exe -ArgumentList "/i", $ghInstaller, "/quiet" -Wait
Remove-Item $ghInstaller

Write-Host "✓ Installation complete. Please restart PowerShell."
```

---

## Step 4: GitHub Authentication (All Platforms)

Now let's authenticate with GitHub:

**macOS/Linux**:

```bash
# Check if already authenticated
if gh auth status >/dev/null 2>&1; then
  echo "✓ Already authenticated with GitHub"
  gh auth status
else
  echo "Setting up GitHub authentication..."
  gh auth login
fi
```

**Windows (PowerShell)**:

```powershell
# Check if already authenticated
try {
  gh auth status 2>$null
  Write-Host "✓ Already authenticated with GitHub" -ForegroundColor Green
  gh auth status
} catch {
  Write-Host "Setting up GitHub authentication..." -ForegroundColor Yellow
  gh auth login
}
```

**This will**:

- Open an interactive authentication flow
- Ask you to choose GitHub.com or GitHub Enterprise
- Provide a one-time code for browser authentication
- Create a credential for the GitHub CLI

---

## Step 5: Verify Installation (All Platforms)

Let's verify everything is configured correctly:

**macOS/Linux**:

```bash
echo "=== Dependency Versions ==="
echo "GitHub CLI: $(gh --version | head -1)"
echo ""
echo "=== Authentication Status ==="
echo "GitHub:"
gh auth status
```

**Windows (PowerShell)**:

```powershell
Write-Host "=== Dependency Versions ===" -ForegroundColor Cyan
Write-Host "GitHub CLI: $(gh --version | Select-String 'gh version')"
Write-Host ""

Write-Host "=== Authentication Status ===" -ForegroundColor Cyan
Write-Host "GitHub:" -ForegroundColor Yellow
gh auth status
```

---

## Troubleshooting

### Installation Issues

#### macOS

- **Homebrew installation fails**:
  - Make sure you have admin access
  - Install Xcode Command Line Tools: `xcode-select --install`
  - Check internet connection

#### Linux

- **apt-get fails**:

  - Make sure you have sudo privileges
  - Run `sudo apt-get update` first
  - Check `/etc/apt/sources.list` for errors

- **GPG key errors**:
  - Clear old keys: `sudo rm -rf /etc/apt/keyrings/githubcli-archive-keyring.gpg`
  - Re-run the installation steps

#### Windows

- **winget not found**:

  - Update Windows to latest version (Windows 10 1809+, Windows 11)
  - Install App Installer from Microsoft Store
  - Use alternative MSI installer method

- **MSI installation fails**:
  - Run PowerShell as Administrator
  - Disable antivirus temporarily
  - Check Windows Installer service is running

### Authentication Issues

#### GitHub Authentication

- **gh auth login fails**:
  - Run `gh auth logout` then `gh auth login` again
  - Choose HTTPS protocol (not SSH) if having issues
  - Make sure browser opens correctly
  - Check firewall settings

### Platform-Specific Issues

#### macOS (Apple Silicon)

- **Homebrew PATH not found**:
  - Run: `eval "$(/opt/homebrew/bin/brew shellenv)"`
  - Add to ~/.zshrc permanently

#### Linux (WSL)

- **Running on WSL**:
  - Follow Linux instructions
  - Ensure WSL2 is installed
  - Use Windows browser for authentication (will open automatically)

#### Windows

- **PowerShell execution policy error**:
  - Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
  - Or use `-ExecutionPolicy Bypass` when running scripts

---

## Manual Configuration (Advanced)

If you prefer to configure manually or the automatic setup doesn't work:

### Install Dependencies Manually

**macOS**:

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# GitHub CLI
brew install gh
```

**Linux (Ubuntu/Debian)**:

```bash
# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list
sudo apt-get update && sudo apt-get install gh
```

**Windows (PowerShell)**:

```powershell
# Using winget
winget install -e --id GitHub.cli
```

### Authenticate Manually

**All Platforms**:

```bash
# GitHub
gh auth login
```

---

## Quick Reference

### Command Summary by Platform

| Task       | macOS             | Linux                 | Windows                     |
| ---------- | ----------------- | --------------------- | --------------------------- |
| Install gh | `brew install gh` | `sudo apt install gh` | `winget install GitHub.cli` |
| Login gh   | `gh auth login`   | `gh auth login`       | `gh auth login`             |
| Check gh   | `gh auth status`  | `gh auth status`      | `gh auth status`            |

---

## Next Steps

After setting up GitHub CLI, you may want to:

1. Configure Azure DevOps integration: Create `azure.md` command
2. Set up MCP servers for enhanced capabilities
3. Test PR review commands

## Need Help?

- **GitHub CLI Docs**: https://cli.github.com/manual/
- **GitHub CLI Authentication**: https://cli.github.com/manual/gh_auth_login
