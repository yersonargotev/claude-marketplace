---
description: "Install and configure Serena MCP for enhanced semantic code analysis with Claude Code"
---

# Serena MCP Setup

This command sets up Serena, a powerful MCP-based coding agent toolkit that provides semantic code retrieval and editing tools for Claude Code.

**Supported Platforms**: macOS, Linux, Windows

## What This Command Does

1. **Installs Prerequisites**:
   - `uv` (Python package manager by Astral)

2. **Configures Serena MCP**:
   - Adds Serena as an MCP server to Claude Code
   - Configures it with the `ide-assistant` context
   - Activates the current project automatically

## What is Serena?

Serena provides IDE-like capabilities to Claude Code:
- **Semantic code search** at the symbol level (functions, classes, variables)
- **Precise code editing** using language server capabilities
- **Support for 30+ programming languages** (Python, TypeScript, Go, Rust, Java, and more)
- **More efficient token usage** through targeted code operations

Unlike file-based or RAG-based tools, Serena uses language servers (LSP) for symbolic understanding of code, making it particularly effective for large and complex codebases.

---

## Step 1: Check if uv is Installed

First, check if `uv` is already installed:

**macOS/Linux**:
```bash
which uv
```

**Windows (PowerShell)**:
```powershell
Get-Command uv -ErrorAction SilentlyContinue
```

If the command returns a path, `uv` is already installed and you can skip to [Step 3](#step-3-add-serena-mcp-to-claude-code).

If not found, proceed to Step 2.

---

## Step 2: Install uv

Install `uv` using the official installer:

**macOS/Linux**:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, you may need to restart your terminal or run:
```bash
source ~/.bashrc  # or ~/.zshrc depending on your shell
```

**Windows (PowerShell)**:
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

After installation, close and reopen PowerShell for changes to take effect.

### Verify Installation

**macOS/Linux**:
```bash
uv --version
```

**Windows (PowerShell)**:
```powershell
uv --version
```

You should see output like: `uv 0.x.x`

---

## Step 3: Add Serena MCP to Claude Code

Run the following command **from your project directory** to add Serena MCP:

**macOS/Linux**:
```bash
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project "$(pwd)"
```

**Windows (PowerShell)**:
```powershell
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project "$PWD"
```

**What this command does**:
- Adds Serena as an MCP server to Claude Code for the current project
- Uses `uvx` to run the latest version directly from GitHub (no local installation needed)
- Configures Serena with the `ide-assistant` context (optimized for IDE integration)
- Automatically activates your current project at startup

---

## Step 4: Verify Installation

After adding Serena, the MCP server is configured. You can verify it's working in your next Claude Code session by:

1. Starting a new conversation
2. Asking: "List the available Serena tools"
3. Or trying: "Show me the symbols in [filename]"

You should see tools like:
- `find_symbol` - Search for functions, classes, variables
- `find_referencing_symbols` - Find all references to a symbol
- `get_symbols_overview` - Get overview of symbols in a file
- `replace_symbol_body` - Replace function/class definitions
- And many more...

---

## Optional: Pre-Index Your Project

For larger projects (recommended for projects with >100 files), pre-indexing will significantly accelerate Serena's operations:

**macOS/Linux**:
```bash
uvx --from git+https://github.com/oraios/serena serena project index
```

**Windows (PowerShell)**:
```powershell
uvx --from git+https://github.com/oraios/serena serena project index
```

Run this from your project directory. The first tool use after indexing will be much faster.

---

## Configuration

### Global Configuration

Serena's global configuration is stored in `~/.serena/serena_config.yml`. You can edit it with:

```bash
uvx --from git+https://github.com/oraios/serena serena config edit
```

### Project Configuration

Project-specific configuration is stored in `.serena/project.yml` within your project directory. This file is auto-generated when you first use Serena on that project.

You can also generate it explicitly:

```bash
uvx --from git+https://github.com/oraios/serena serena project generate-yml
```

---

## Key Features & Tools

Once installed, Serena provides these powerful tools:

### Code Discovery
- **`find_symbol`**: Search for functions, classes, variables by name (supports wildcards)
- **`find_referencing_symbols`**: Find all references to a symbol across the codebase
- **`get_symbols_overview`**: Get an overview of top-level symbols in a file
- **`find_file`**: Find files by path patterns

### Code Editing
- **`replace_symbol_body`**: Replace entire function/class definitions
- **`insert_after_symbol`** / **`insert_before_symbol`**: Precise code insertion
- **`rename_symbol`**: Refactor symbol names across the entire codebase
- **`replace_regex`**: Pattern-based replacements

### Project Navigation
- **`list_dir`**: List files and directories
- **`read_file`**: Read file contents
- **`search_for_pattern`**: Search for patterns in the project

### Knowledge Management
- **`write_memory`** / **`read_memory`**: Store and retrieve project-specific knowledge
- **`onboarding`**: Perform project onboarding to create initial memories

---

## Language Support

Serena supports **30+ programming languages** out of the box:

**Tier 1 (Full Support)**:
- Python, TypeScript, JavaScript, Go, Rust
- Java, PHP, Ruby, C/C++, C#
- Swift, Kotlin, Dart, Bash, Lua

**Additional Languages**:
- Nix, Elixir, Elm, Scala, Erlang
- Perl, Fortran, Haskell, Julia, Zig
- AL, Markdown, Clojure

Some languages may require additional setup (e.g., `gopls` for Go, `rustup` for Rust). Serena will guide you through any required installations.

---

## Troubleshooting

### Serena tools not appearing

**Check MCP configuration**:
```bash
claude mcp list
```

You should see `serena` in the list. If not, re-run Step 3.

**Restart Claude Code**:
After adding the MCP server, you may need to start a fresh conversation or restart Claude Code.

### uv command not found

**macOS/Linux**:
```bash
# Add to your shell configuration
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc
```

**Windows**:
Close and reopen PowerShell, or add `%USERPROFILE%\.local\bin` to your PATH environment variable.

### Language server issues

Some languages require additional setup:
- **Go**: Install `gopls` with `go install golang.org/x/tools/gopls@latest`
- **Rust**: Install via `rustup` (uses rust-analyzer from your toolchain)
- **PHP**: Set `INTELEPHENSE_LICENSE_KEY` environment variable for premium features

Check Serena's logs for specific language server errors:
- **macOS/Linux**: `~/.serena/logs/`
- **Windows**: `%USERPROFILE%\.serena\logs\`

### Performance issues

**For large projects**:
1. Pre-index your project (see Optional step above)
2. Create a `.serenignore` file to exclude directories:
   ```
   node_modules/
   .venv/
   dist/
   build/
   ```

**First tool use is slow**:
This is normal for large projects. Serena needs to start language servers and build an initial index. Subsequent uses will be much faster.

### Docker/Container environments

If working in a container, you may need to:
1. Install language-specific tools (go, rustup, etc.) in the container
2. Map your project directory to the container
3. Run Serena in Streamable HTTP mode for cross-container communication

---

## Advanced: Using Serena Dashboard

Serena provides a web-based dashboard for monitoring logs and tool usage:

**Access the dashboard**:
When Serena is running, open: `http://localhost:24282/dashboard/index.html`

The dashboard shows:
- Real-time logs
- Tool usage statistics (if enabled in config)
- Server status
- Shutdown controls

**Enable tool usage statistics** in `~/.serena/serena_config.yml`:
```yaml
record_tool_usage_stats: true
```

---

## Updating Serena

Serena updates automatically! Since the MCP configuration uses `uvx --from git+...`, it always fetches the latest version from GitHub when Claude Code starts a new session.

To force an update:
1. No action needed - just start a new Claude Code session
2. Or manually run: `uvx --from git+https://github.com/oraios/serena serena --version`

---

## Learn More

- **GitHub Repository**: https://github.com/oraios/serena
- **Full Documentation**: See README in the repository
- **Supported Languages**: Full list with setup requirements in docs
- **Community**: GitHub Issues and Discussions

---

## Quick Reference

### Command Summary

| Task | Command |
|------|---------|
| Install uv (Unix) | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| Install uv (Windows) | `irm https://astral.sh/uv/install.ps1 \| iex` |
| Add Serena to Claude Code | `claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context ide-assistant --project "$(pwd)"` |
| Index project | `uvx --from git+https://github.com/oraios/serena serena project index` |
| Edit config | `uvx --from git+https://github.com/oraios/serena serena config edit` |
| List MCP servers | `claude mcp list` |

---

## Why Use Serena?

- **Free & Open Source**: No API keys or subscriptions required
- **Language Server Integration**: Symbolic code understanding, not just text/RAG
- **Token Efficient**: Precise operations reduce token usage and costs
- **Proven Results**: Community reports significant productivity improvements
- **Framework Agnostic**: Works with Claude Code, Claude Desktop, and other MCP clients

---

**Note**: Serena is community-driven and actively developed. Star the repository on GitHub to stay updated with new features and improvements!
