# MCP Server Integration

MCP (Model Context Protocol) servers extend your plugin with external tools and data sources. This guide covers setup, configuration, and usage patterns.

## MCP Overview

### What is MCP?

MCP servers provide:
- **External tool access**: GitHub, Sentry, Linear, Jira, etc.
- **Up-to-date docs**: Context7 for library documentation
- **Database queries**: PostgreSQL, MongoDB, etc.
- **API integration**: REST APIs, GraphQL, etc.
- **Custom tools**: Build your own integrations

### How MCP Works

```
Claude Code Plugin
      ↓
   .mcp.json config
      ↓
  MCP Server (HTTP/SSE)
      ↓
External Service (GitHub, Sentry, etc.)
```

## Configuration

### Basic Setup

Create `.mcp.json` in your plugin root:

```json
{
  "mcpServers": {
    "server-name": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "API_KEY": "${API_KEY_ENV_VAR}"
      },
      "description": "What this server provides"
    }
  }
}
```

### Configuration Fields

| Field | Description | Example |
|-------|-------------|---------|
| `type` | Connection type | `"http"`, `"sse"` |
| `url` | Server endpoint | `"https://mcp.context7.com/mcp"` |
| `headers` | Authentication headers | `{"API_KEY": "${KEY}"}` |
| `description` | Server purpose | `"GitHub integration"` |

### Environment Variables

Use `${VAR_NAME}` syntax for sensitive data:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}"
      }
    }
  }
}
```

**User setup**:
```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
# Make persistent
echo 'export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"' >> ~/.zshrc
```

## Real-World Examples

### 1. Context7 (Documentation)

Access up-to-date library documentation:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Up-to-date documentation for any library/framework"
    }
  }
}
```

**Available tools**:
- `mcp__context7__resolve-library-id`: Resolve library names to IDs
- `mcp__context7__get-library-docs`: Fetch docs for specific library

**Usage in agent**:

```markdown
---
name: docs-assistant
description: "Helps with library usage and examples"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

You are a documentation assistant.

**Workflow**:
1. Resolve library name to ID:
   Use: mcp__context7__resolve-library-id with libraryName: $1
   Example: "react" → "/facebook/react"

2. Fetch documentation:
   Use: mcp__context7__get-library-docs with:
   - context7CompatibleLibraryID: "/facebook/react"
   - topic: $2 (e.g., "hooks")
   - tokens: 5000

3. Extract relevant information
4. Provide code examples
5. Suggest best practices
```

**Example invocation**:
```bash
/docs-help react hooks
```

### 2. Azure DevOps

Integrate with Azure DevOps for work item tracking:

```json
{
  "mcpServers": {
    "azure-devops": {
      "type": "http",
      "url": "https://dev.azure.com/${AZURE_DEVOPS_ORG}/_apis/mcp",
      "headers": {
        "Authorization": "Basic ${AZURE_DEVOPS_PAT_BASE64}"
      },
      "description": "Azure DevOps work item and repository integration"
    }
  }
}
```

**Available tools** (via exito plugin):
- `mcp__microsoft_azu_wit_get_work_item`: Fetch work item details
- `mcp__microsoft_azu_wit_list_work_items`: List work items
- `mcp__microsoft_azu_repo_get_pull_request`: Get PR details
- `mcp__microsoft_azu_repo_list_pull_requests`: List PRs

**Usage in agent**:

```markdown
---
name: business-validator
description: "Validates code changes against User Stories"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

You are a Business Analyst.

**Workflow**:
1. Read PR context from: $1 (.claude/sessions/pr_reviews/pr_X_context.md)

2. For each Azure DevOps URL in $2, $3, $4...:
   Extract work item ID
   Fetch work item with: mcp__microsoft_azu_wit_get_work_item
   Extract:
   - Title
   - Description
   - Acceptance criteria
   - Status

3. Compare PR changes against acceptance criteria:
   - Are all criteria addressed?
   - Are there extra changes not in requirements?
   - Does implementation match intent?

4. Append findings to: $1 (context file)

5. Return summary:
   - Work items validated: X
   - Criteria met: Y/Z
   - Alignment score: A/10
```

### 3. GitHub

Native GitHub integration:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp",
      "headers": {
        "Authorization": "Bearer ${GITHUB_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
      },
      "description": "GitHub repository and PR management"
    }
  }
}
```

**Note**: Many plugins use GitHub CLI (`gh`) instead of MCP, which is simpler:

```markdown
---
tools: Bash(gh:*)
---

Fetch PR details:
!gh pr view $1 --json title,body,files,diff
```

### 4. Sentry (Error Tracking)

Integrate error tracking:

```json
{
  "mcpServers": {
    "sentry": {
      "type": "http",
      "url": "https://sentry.io/api/mcp",
      "headers": {
        "Authorization": "Bearer ${SENTRY_AUTH_TOKEN}"
      },
      "description": "Sentry error tracking and monitoring"
    }
  }
}
```

**Usage**:

```markdown
---
name: error-analyzer
description: "Analyzes errors from Sentry"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

Fetch recent errors for project:
Use: mcp__sentry__get_project_issues with:
- project: $1
- status: "unresolved"
- limit: 50

Analyze error patterns:
- Most common errors
- Affected users
- Stack traces
- Suggested fixes
```

### 5. Linear (Project Management)

```json
{
  "mcpServers": {
    "linear": {
      "type": "http",
      "url": "https://api.linear.app/mcp",
      "headers": {
        "Authorization": "${LINEAR_API_KEY}"
      },
      "description": "Linear issue tracking"
    }
  }
}
```

## Tool Discovery

### Finding Available Tools

After configuring MCP server, restart Claude Code and tools become available.

**List tools** (in Claude Code):
```bash
/help
```

Look for `mcp__[server-name]__[tool-name]` pattern.

### Tool Naming Convention

```
mcp__[server]__[tool-name]

Examples:
- mcp__context7__get-library-docs
- mcp__github__create_pr
- mcp__sentry__get_project_issues
```

## Using MCP Tools in Agents

### Grant MCP Tool Access

MCP tools are available automatically when server is configured. No special permission needed in agent frontmatter.

```yaml
---
name: my-agent
tools: Read, Write  # MCP tools are available by default
---
```

### Call MCP Tools

Use function call syntax:

```markdown
**Step 1: Resolve Library**
Use tool: mcp__context7__resolve-library-id
Parameters:
- libraryName: "react"

Expected result: "/facebook/react"

**Step 2: Fetch Docs**
Use tool: mcp__context7__get-library-docs
Parameters:
- context7CompatibleLibraryID: "/facebook/react"
- topic: "hooks"
- tokens: 5000

Expected result: Documentation content about React hooks
```

### Error Handling

```markdown
**Error Handling**:
- If MCP server unavailable: "Context7 unavailable. Using built-in knowledge."
- If tool returns error: Log error, provide fallback
- If authentication fails: "MCP authentication failed. Check ${API_KEY} env var."
```

## Authentication Patterns

### API Keys (Simple)

```json
{
  "headers": {
    "API_KEY": "${SERVICE_API_KEY}"
  }
}
```

**Setup**:
```bash
export SERVICE_API_KEY="key_xxxxxx"
```

### Bearer Tokens

```json
{
  "headers": {
    "Authorization": "Bearer ${SERVICE_TOKEN}"
  }
}
```

**Setup**:
```bash
export SERVICE_TOKEN="tok_xxxxxx"
```

### Basic Auth

```json
{
  "headers": {
    "Authorization": "Basic ${SERVICE_BASIC_AUTH}"
  }
}
```

**Setup** (encode username:password):
```bash
echo -n "user:password" | base64
export SERVICE_BASIC_AUTH="dXNlcjpwYXNzd29yZA=="
```

### OAuth (Advanced)

```json
{
  "type": "oauth",
  "oauth": {
    "client_id": "${OAUTH_CLIENT_ID}",
    "client_secret": "${OAUTH_CLIENT_SECRET}",
    "authorization_url": "https://example.com/oauth/authorize",
    "token_url": "https://example.com/oauth/token",
    "scopes": ["read", "write"]
  }
}
```

## Security Best Practices

### 1. Never Hardcode Secrets

```json
# ❌ BAD: Hardcoded token
{
  "headers": {
    "Authorization": "Bearer ghp_abc123secret"
  }
}

# ✅ GOOD: Environment variable
{
  "headers": {
    "Authorization": "Bearer ${GITHUB_TOKEN}"
  }
}
```

### 2. Minimal Scopes

Request only necessary permissions:

```json
{
  "oauth": {
    "scopes": ["repo:read"]  # Not "repo:*"
  }
}
```

### 3. Validate Responses

```markdown
**Validation**:
After MCP tool call:
1. Check response status
2. Validate data structure
3. Sanitize output
4. Handle errors gracefully
```

### 4. Rate Limiting

```markdown
**Rate Limiting**:
If MCP tool returns rate limit error:
- Wait and retry with exponential backoff
- Cache responses when possible
- Batch requests
- Inform user of limitation
```

## Testing MCP Integration

### 1. Test Connection

Create simple test command:

```markdown
---
description: "Test MCP server connection"
---

Test Context7 connection:

1. Resolve library: mcp__context7__resolve-library-id with libraryName: "react"
2. If successful: "✓ Context7 connected"
3. If failed: "✗ Context7 unavailable. Check CONTEXT7_API_KEY"
```

### 2. Test Tool Calls

```markdown
**Test Workflow**:
1. Call: mcp__context7__get-library-docs with:
   - context7CompatibleLibraryID: "/facebook/react"
   - topic: "hooks"
   - tokens: 1000

2. Verify response contains:
   - Documentation text
   - Code examples
   - Expected format

3. Report: "✓ MCP tool working" or "✗ Error: [details]"
```

### 3. Test Authentication

```bash
# Test env var is set
echo $CONTEXT7_API_KEY

# Test API directly (if HTTP MCP)
curl -H "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" https://mcp.context7.com/health

# Test via Claude Code
/test-mcp-connection
```

## Common Issues

### Issue 1: Tool Not Found

**Symptom**: `mcp__context7__get-library-docs not found`

**Causes**:
1. MCP server not configured in `.mcp.json`
2. Claude Code not restarted after config change
3. Server URL incorrect

**Fix**:
1. Verify `.mcp.json` exists and is valid
2. Restart Claude Desktop completely
3. Check server URL in config

### Issue 2: Authentication Failed

**Symptom**: `401 Unauthorized` or `403 Forbidden`

**Causes**:
1. Environment variable not set
2. Token expired or invalid
3. Insufficient permissions

**Fix**:
```bash
# Check env var
echo $API_KEY

# Set env var
export API_KEY="your-key"

# Make persistent
echo 'export API_KEY="your-key"' >> ~/.zshrc

# Restart Claude Code
```

### Issue 3: Timeout

**Symptom**: MCP tool call hangs or times out

**Causes**:
1. Server down or slow
2. Network issues
3. Large response

**Fix**:
- Add timeout handling in agent
- Implement retry logic
- Use smaller token limits
- Cache responses

### Issue 4: Rate Limited

**Symptom**: `429 Too Many Requests`

**Causes**:
1. Exceeded API rate limit
2. Too many concurrent requests

**Fix**:
```markdown
**Rate Limit Handling**:
If rate limited:
1. Wait 60 seconds
2. Retry with exponential backoff
3. Reduce request frequency
4. Cache responses
```

## Advanced Patterns

### 1. Conditional MCP Usage

```markdown
**Workflow**:
Try to fetch latest docs with Context7:
  Use: mcp__context7__get-library-docs
  If successful: Use fresh docs
  If failed: Fall back to built-in knowledge

This allows graceful degradation when MCP unavailable.
```

### 2. MCP Response Caching

```markdown
**Caching Strategy**:
1. Check if docs cached: .claude/cache/context7/react-hooks.md
2. If cache exists and < 24h old: Use cache
3. Else: Fetch from Context7, update cache
4. Use cached docs

Benefits:
- Faster responses
- Reduced API calls
- Works offline (with stale cache)
```

### 3. Multi-Source Integration

```markdown
**Multi-Source Pattern**:
1. Fetch PR data: GitHub CLI (gh pr view)
2. Fetch work items: Azure DevOps MCP
3. Fetch error data: Sentry MCP
4. Fetch docs: Context7 MCP

Synthesize all sources into comprehensive analysis.
```

### 4. Tool Composition

```markdown
**Composed Workflow**:
1. List open issues: mcp__github__list_issues
2. For each issue:
   - Fetch Sentry errors: mcp__sentry__get_issue
   - Fetch relevant docs: mcp__context7__get-library-docs
   - Analyze and suggest fix
3. Create PR with fixes: gh CLI
4. Link PR to issues: mcp__github__link_pr
```

## Best Practices

### 1. Document Requirements

```markdown
## Prerequisites

This plugin requires:
- Context7 API key: https://context7.com
- Azure DevOps PAT: https://dev.azure.com/[org]/_usersSettings/tokens

Setup:
```bash
export CONTEXT7_API_KEY="your-key"
export AZURE_DEVOPS_PAT="your-pat"
```

Restart Claude Code after setting environment variables.
```

### 2. Provide Setup Command

```markdown
---
description: "Setup MCP server authentication"
---

You are a setup assistant.

Guide user through MCP setup:

1. Context7:
   - Visit: https://context7.com
   - Get API key
   - Run: export CONTEXT7_API_KEY="your-key"

2. Azure DevOps:
   - Visit: https://dev.azure.com/[org]/_usersSettings/tokens
   - Create PAT with Work Items: Read scope
   - Run: export AZURE_DEVOPS_PAT="your-pat"

3. Make persistent:
   - Add to ~/.zshrc or ~/.bashrc
   - Restart Claude Code

4. Test:
   - Run: /test-mcp-connection
```

### 3. Graceful Fallback

```markdown
**Fallback Strategy**:
Try MCP tool:
  If success: Use result
  If failure: Fall back to alternative

Examples:
- Context7 unavailable → Use built-in knowledge
- GitHub MCP fails → Use gh CLI
- Sentry unreachable → Skip error analysis
```

### 4. Clear Error Messages

```markdown
**Error Messages**:
If MCP fails:
"Unable to fetch documentation from Context7.

Possible causes:
1. API key not set (run: export CONTEXT7_API_KEY='your-key')
2. API key invalid (get new key at https://context7.com)
3. Server unavailable (check https://status.context7.com)

Falling back to built-in knowledge (may be outdated)."
```

## Complete Example: Docs Assistant

```markdown
---
description: "Get up-to-date docs and examples for any library"
argument-hint: "<LIBRARY> [TOPIC]"
---

You are a documentation assistant with access to Context7 for fresh docs.

**Input**:
- $1: Library name (e.g., "react", "nextjs", "typescript")
- $2: Optional topic (e.g., "hooks", "routing", "types")

**Workflow**:

### Step 1: Resolve Library
Use: mcp__context7__resolve-library-id
Parameters:
  libraryName: $1

Expected: Context7 library ID (e.g., "/facebook/react")

If not found:
  "Library '$1' not found in Context7. Try alternative name or check spelling."

### Step 2: Fetch Documentation
Use: mcp__context7__get-library-docs
Parameters:
  context7CompatibleLibraryID: [from step 1]
  topic: $2 (if provided)
  tokens: 5000

Expected: Fresh documentation and examples

If MCP fails:
  "Context7 unavailable. Using built-in knowledge (may be outdated).
   Setup Context7: export CONTEXT7_API_KEY='your-key' from https://context7.com"

### Step 3: Extract Relevant Info
From documentation:
- Core concepts
- Common patterns
- Code examples
- Best practices
- Recent changes

### Step 4: Present to User
Format:
## [$1] Documentation

**Overview**: [Brief description]

**Key Concepts**:
- [Concept 1]
- [Concept 2]

**Code Examples**:
```language
[Example 1 with explanation]
```

```language
[Example 2 with explanation]
```

**Best Practices**:
- [Practice 1]
- [Practice 2]

**Resources**:
- Official docs: [link]
- Related topics: [links]

**Note**: Documentation fetched from Context7 on [date]. For latest updates, visit official docs.

**Error Handling**:
- If library not found: Suggest alternative names
- If MCP unavailable: Use built-in knowledge, note limitation
- If topic not found: Show general docs, list available topics
```

## Summary

- **Configure** MCP servers in `.mcp.json`
- **Use environment variables** for secrets (never hardcode)
- **Test connections** before deploying
- **Handle errors gracefully** with fallbacks
- **Document requirements** clearly for users
- **Cache responses** when possible
- **Validate inputs** and sanitize outputs
- **Provide setup guidance** in plugin docs

MCP servers dramatically expand plugin capabilities. Use them to integrate with external services, fetch fresh data, and provide comprehensive analysis.

Next: Read [HOOKS.md](HOOKS.md) to learn about event-driven automation with hooks.
