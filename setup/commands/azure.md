---
description: "Install and configure Azure CLI for Azure DevOps integration (macOS, Linux, Windows)"
---

# Azure CLI Setup

This command installs and configures Azure CLI for Azure DevOps integration, enabling the business-validator agent to fetch User Story details.

**Supported Platforms**: macOS, Linux (Ubuntu/Debian), Windows

## What This Command Does

1. **Installs Dependencies** (if missing):

   - Package manager (Homebrew/apt/winget)
   - Azure CLI (`az`)

2. **Configures Authentication**:
   - Azure CLI login for Azure DevOps
   - No subscription required (uses `--allow-no-subscriptions`)

## Prerequisites

- **macOS**: Admin access for installing dependencies
- **Linux**: sudo access (Ubuntu/Debian-based distributions)
- **Windows**: PowerShell 5.1+ or PowerShell 7+ with admin privileges
- **Azure Account**: Access to Azure DevOps organization

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

### Step 3a: Install Azure CLI (macOS)

```bash
if command -v az >/dev/null 2>&1; then
  echo "✓ Azure CLI is already installed ($(az --version | head -1))"
else
  echo "✗ Azure CLI is not installed"
  echo "Installing Azure CLI via Homebrew..."
  brew install azure-cli
  echo "✓ Azure CLI installed successfully"
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

### Step 3b: Install Azure CLI (Linux)

```bash
if command -v az >/dev/null 2>&1; then
  echo "✓ Azure CLI is already installed ($(az --version | head -1))"
else
  echo "✗ Azure CLI is not installed"
  echo "Installing Azure CLI..."

  # Install prerequisites
  sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg

  # Download and install Microsoft signing key
  sudo mkdir -p /etc/apt/keyrings
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
  sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

  # Add Azure CLI repository
  AZ_DIST=$(lsb_release -cs)
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_DIST main" | sudo tee /etc/apt/sources.list.d/azure-cli.list

  # Install Azure CLI
  sudo apt-get update
  sudo apt-get install -y azure-cli

  echo "✓ Azure CLI installed successfully"
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

### Step 3c: Install Azure CLI (Windows)

```powershell
# Check if az is installed
if (Get-Command az -ErrorAction SilentlyContinue) {
  $azVersion = az --version | Select-String -Pattern "azure-cli" | Select-Object -First 1 | Out-String
  Write-Host "✓ Azure CLI is already installed ($($azVersion.Trim()))" -ForegroundColor Green
} else {
  Write-Host "✗ Azure CLI is not installed" -ForegroundColor Red
  Write-Host "Installing Azure CLI via winget..." -ForegroundColor Yellow

  winget install -e --id Microsoft.AzureCLI

  Write-Host "✓ Azure CLI installed successfully" -ForegroundColor Green
  Write-Host "Please close and reopen PowerShell for changes to take effect."
}
```

**Alternative Windows Installation (MSI Installer)**:

If winget is not available, you can install manually:

```powershell
# Azure CLI MSI
Write-Host "Downloading Azure CLI installer..."
$azUrl = "https://aka.ms/installazurecliwindows"
$azInstaller = "$env:TEMP\azure_cli_installer.msi"
Invoke-WebRequest -Uri $azUrl -OutFile $azInstaller
Start-Process msiexec.exe -ArgumentList "/i", $azInstaller, "/quiet" -Wait
Remove-Item $azInstaller

Write-Host "✓ Installation complete. Please restart PowerShell."
```

---

## Step 4: Azure CLI Authentication (All Platforms)

Now let's authenticate with Azure for Azure DevOps integration:

**macOS/Linux**:

```bash
# Check if already authenticated
if az account show >/dev/null 2>&1; then
  echo "✓ Already authenticated with Azure"
  az account show --query "{Name:name, SubscriptionId:id, TenantId:tenantId}" -o table
else
  echo "Setting up Azure authentication..."
  az login --allow-no-subscriptions
fi
```

**Windows (PowerShell)**:

```powershell
# Check if already authenticated
try {
  az account show 2>$null | Out-Null
  Write-Host "✓ Already authenticated with Azure" -ForegroundColor Green
  az account show --query "{Name:name, SubscriptionId:id, TenantId:tenantId}" -o table
} catch {
  Write-Host "Setting up Azure authentication..." -ForegroundColor Yellow
  az login --allow-no-subscriptions
}
```

**This will**:

- Open your browser for authentication
- Allow access without requiring Azure subscriptions
- Enable the business-validator agent to fetch User Story details from Azure DevOps

**Note**: Authentication persists across sessions, so you only need to do this once.

---

## Step 5: Verify Installation (All Platforms)

Let's verify everything is configured correctly:

**macOS/Linux**:

```bash
echo "=== Dependency Versions ==="
echo "Azure CLI: $(az --version | head -1)"
echo ""
echo "=== Authentication Status ==="
echo "Azure:"
az account show --query "{Name:name, TenantId:tenantId}" -o table 2>/dev/null || echo "Not authenticated"
```

**Windows (PowerShell)**:

```powershell
Write-Host "=== Dependency Versions ===" -ForegroundColor Cyan
Write-Host "Azure CLI: $(az --version | Select-String 'azure-cli' | Select-Object -First 1)"
Write-Host ""

Write-Host "=== Authentication Status ===" -ForegroundColor Cyan
Write-Host "Azure:" -ForegroundColor Yellow
try {
  az account show --query "{Name:name, TenantId:tenantId}" -o table
} catch {
  Write-Host "Not authenticated" -ForegroundColor Red
}
```

---

## Step 6: Configure Azure DevOps Extension (Optional)

For enhanced Azure DevOps integration, install the Azure DevOps extension:

**All Platforms**:

```bash
# Install Azure DevOps extension
az extension add --name azure-devops

# Verify installation
az extension list --output table | grep azure-devops
```

**Configure default organization** (optional):

```bash
# Set default organization
az devops configure --defaults organization=https://dev.azure.com/your-organization

# Verify configuration
az devops configure --list
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
  - Clear old keys: `sudo rm -rf /etc/apt/keyrings/microsoft.gpg`
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

#### Azure CLI Authentication

- **az login fails**:

  - Run `az logout` then `az login --allow-no-subscriptions` again
  - Clear browser cache and cookies
  - Try different browser
  - Check Microsoft account credentials

- **Business validator not working**:
  - Verify authentication: `az account show`
  - Check Azure DevOps organization access
  - Ensure you have permissions to view Work Items
  - Verify User Story URLs are correct format

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

### Azure DevOps Specific Issues

- **Cannot access Work Items**:

  - Ensure you're a member of the Azure DevOps organization
  - Check project permissions (Basic access minimum)
  - Verify the organization URL is correct

- **Extension installation fails**:
  - Update Azure CLI: `az upgrade`
  - Remove and reinstall extension: `az extension remove --name azure-devops && az extension add --name azure-devops`

---

## Manual Configuration (Advanced)

If you prefer to configure manually or the automatic setup doesn't work:

### Install Dependencies Manually

**macOS**:

```bash
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Azure CLI
brew install azure-cli
```

**Linux (Ubuntu/Debian)**:

```bash
# Azure CLI
curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update && sudo apt-get install azure-cli
```

**Windows (PowerShell)**:

```powershell
# Using winget
winget install -e --id Microsoft.AzureCLI
```

### Authenticate Manually

**All Platforms**:

```bash
# Azure
az login --allow-no-subscriptions

# Install Azure DevOps extension (optional)
az extension add --name azure-devops
```

---

## Quick Reference

### Command Summary by Platform

| Task              | macOS                                  | Linux                                  | Windows                                |
| ----------------- | -------------------------------------- | -------------------------------------- | -------------------------------------- |
| Install az        | `brew install azure-cli`               | `sudo apt install azure-cli`           | `winget install Microsoft.AzureCLI`    |
| Login az          | `az login --allow-no-subscriptions`    | `az login --allow-no-subscriptions`    | `az login --allow-no-subscriptions`    |
| Check az          | `az account show`                      | `az account show`                      | `az account show`                      |
| Install extension | `az extension add --name azure-devops` | `az extension add --name azure-devops` | `az extension add --name azure-devops` |

---

## Environment Variables (Optional)

For enhanced Azure DevOps integration, you can set these environment variables:

**macOS/Linux** (add to ~/.zshrc or ~/.bashrc):

```bash
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/your-organization"
export AZURE_DEVOPS_PAT="your-personal-access-token"  # If using PAT authentication
```

**Windows** (PowerShell profile):

```powershell
$env:AZURE_DEVOPS_ORG_URL = "https://dev.azure.com/your-organization"
$env:AZURE_DEVOPS_PAT = "your-personal-access-token"  # If using PAT authentication
```

**Note**: PAT authentication is optional. The `az login` method is recommended for interactive use.

---

## Next Steps

After setting up Azure CLI, you can:

1. Test business-validator agent with PR reviews
2. Configure Azure DevOps organization defaults
3. Install GitHub CLI if not already installed (use `github.md`)
4. Set up MCP servers for enhanced capabilities

## Need Help?

- **Azure CLI Docs**: https://learn.microsoft.com/en-us/cli/azure/
- **Azure DevOps CLI**: https://learn.microsoft.com/en-us/azure/devops/cli/
- **Authentication Guide**: https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli
