# Git Commit Examples

This file provides commit message examples for different types of changes.

## Format

```
{type}({scope}): {subject}

{body}

{footer}
```

## Feature Commits

### Example 1: New Feature
```bash
git commit -m "feat(auth): add OAuth2 refresh token support

Implements automatic token refresh when access token expires.
Stores refresh token securely in httpOnly cookie.
Adds refresh token rotation for improved security.

Related to: session-abc123"
```

### Example 2: Feature Enhancement
```bash
git commit -m "feat(dashboard): add real-time data updates

Implements WebSocket connection for live dashboard updates.
Updates UI reactively when data changes on server.
Includes fallback to polling for unsupported browsers.

Related to: session-def456"
```

## Bug Fix Commits

### Example 1: Simple Bug Fix
```bash
git commit -m "fix(api): handle null response from user service

Added null check before accessing user data properties.
Prevents TypeError when service returns null for deleted users.

Fixes: session-ghi789"
```

### Example 2: Critical Bug Fix
```bash
git commit -m "fix(payment): prevent duplicate charge processing

Added idempotency key validation to prevent double charges.
Implements database-level constraint for charge uniqueness.
Adds retry logic with exponential backoff.

Fixes: #PROD-456
Related to: session-jkl012"
```

## Refactor Commits

### Example 1: Component Extraction
```bash
git commit -m "refactor(components): extract UserAvatar to shared component

Moved duplicate avatar logic to reusable component.
Reduces code duplication across 5 files.
Improves maintainability and consistency.

Related to: session-mno345"
```

### Example 2: Code Organization
```bash
git commit -m "refactor(api): restructure endpoint handlers

Organized handlers by domain (users, products, orders).
Extracted common middleware to shared utilities.
Improves code organization and testability.

Related to: session-pqr678"
```

## Test Commits

### Example 1: Add Tests
```bash
git commit -m "test(auth): add unit tests for token refresh logic

Adds comprehensive test coverage for refresh token flow.
Tests success cases, error cases, and edge cases.
Coverage increased from 65% to 92%.

Related to: session-stu901"
```

### Example 2: Fix Flaky Tests
```bash
git commit -m "test(integration): fix flaky user creation tests

Adds proper async handling and cleanup between tests.
Uses test fixtures instead of random data.
Eliminates race conditions in parallel test execution.

Related to: session-vwx234"
```

## Documentation Commits

### Example 1: API Documentation
```bash
git commit -m "docs(api): add OpenAPI spec for user endpoints

Documents all user-related API endpoints.
Includes request/response schemas and examples.
Adds authentication requirements.

Related to: session-yza567"
```

### Example 2: README Update
```bash
git commit -m "docs: update setup instructions for development

Adds prerequisites and environment setup steps.
Includes troubleshooting section for common issues.
Updates dependency versions.

Related to: session-bcd890"
```

## Style/Formatting Commits

```bash
git commit -m "style: apply prettier formatting to components

Applies consistent formatting across all React components.
No functional changes.

Related to: session-efg123"
```

## Chore Commits

### Example 1: Dependency Update
```bash
git commit -m "chore: upgrade React to v18.2.0

Updates React and related dependencies.
Includes migration to new concurrent features.
All tests passing after upgrade.

Related to: session-hij456"
```

### Example 2: Build Configuration
```bash
git commit -m "chore(build): optimize webpack configuration

Reduces bundle size by 25% through code splitting.
Enables tree shaking for unused exports.
Improves build time by 40%.

Related to: session-klm789"
```

## Multi-Scope Commits

```bash
git commit -m "feat(api,ui): implement user search functionality

API: Adds search endpoint with filtering and pagination
UI: Implements search interface with real-time results
Tests: Adds unit and integration tests for search

Related to: session-nop012"
```

## Breaking Changes

```bash
git commit -m "feat(api): migrate to v2 authentication

BREAKING CHANGE: Authentication now requires OAuth2 tokens instead of API keys.

Migration guide:
1. Generate OAuth2 credentials in developer portal
2. Update client to use new token endpoint
3. Replace API key header with Bearer token

Related to: session-qrs345"
```

## Tips

- **Subject line**: 50 characters or less, imperative mood ("add" not "added")
- **Body**: Wrap at 72 characters, explain WHAT and WHY (not HOW)
- **Footer**: Reference issues, PRs, or session IDs
- **Atomic commits**: One logical change per commit
- **Types**: feat, fix, refactor, test, docs, style, chore, perf, ci
- **Scope**: Optional but helpful (auth, api, ui, database, etc.)
