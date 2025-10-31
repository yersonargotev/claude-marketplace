# Plugin Architecture Examples

Real-world examples of commands, agents, and plugin structures.

## Table of Contents

1. [Simple Command Example](#simple-command-example)
2. [Orchestrator Command Example](#orchestrator-command-example)
3. [Context Gatherer Agent Example](#context-gatherer-agent-example)
4. [Analyzer Agent Example](#analyzer-agent-example)
5. [Complete Plugin Example](#complete-plugin-example)
6. [Token Optimization Example](#token-optimization-example)

---

## Simple Command Example

A straightforward command that performs a single task.

**File**: `.claude/commands/setup-github.md`

```yaml
---
description: "Install and configure GitHub CLI for PR operations"
---

# Setup GitHub CLI

Install and authenticate GitHub CLI for use with PR review commands.

## Prerequisites

- Homebrew (macOS/Linux)
- GitHub account

## Installation

### Step 1: Install GitHub CLI

For macOS:
```bash
brew install gh
```

For Linux:
```bash
# Debian/Ubuntu
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh
```

### Step 2: Verify Installation

```bash
gh --version
```

Expected output:
```
gh version 2.x.x (2024-xx-xx)
```

### Step 3: Authenticate

```bash
gh auth login
```

Follow prompts:
1. Choose "GitHub.com"
2. Select "HTTPS"
3. Authenticate via browser
4. Authorize CLI access

### Step 4: Verify Authentication

```bash
gh auth status
```

Expected output:
```
✓ Logged in to github.com as username
```

## Troubleshooting

### Error: command not found: gh

**Solution**: Ensure Homebrew is installed and try again:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
```

### Error: authentication failed

**Solution**: Try alternative auth method:
```bash
gh auth login --web
```

## Next Steps

After setup, you can use PR review commands:
- `/review <PR_NUMBER>`
- `/review-perf <PR_NUMBER>`
- `/review-sec <PR_NUMBER>`
```

---

## Orchestrator Command Example

A command that coordinates multiple agents in a structured workflow.

**File**: `.claude/commands/review.md`

```yaml
---
description: "Comprehensive PR code review using specialized agents"
argument-hint: "<PR_NUMBER> [AZURE_DEVOPS_URL]"
---

# Comprehensive PR Review

Performs multi-dimensional code review using specialized analysis agents.

## Arguments

- `<PR_NUMBER>` (required): GitHub PR number to review
- `[AZURE_DEVOPS_URL]` (optional): Azure DevOps work item URL for business validation

## Prerequisites

- GitHub CLI authenticated: `gh auth status`
- Azure CLI authenticated (if using work item validation): `az login`

## Workflow

### Phase 1: Setup and Validation

Validate arguments and setup session:

1. Check if `$1` (PR_NUMBER) is provided:
   - If empty: Display usage and exit
   - If provided: Continue

2. Create session directory:
   ```bash
   mkdir -p .claude/sessions/pr_reviews
   ```

3. Verify GitHub CLI authentication:
   - Run: `gh auth status`
   - If not authenticated: Provide error with `gh auth login` instructions

### Phase 2: Context Gathering

Invoke context-gatherer agent to establish single source of truth.

Use the Task tool to invoke `context-gatherer` agent:
- **Agent**: `context-gatherer`
- **Arguments**: Pass PR number as `$1`
- **Wait for completion**

Expected output:
- Context file created: `.claude/sessions/pr_reviews/pr_{number}_context.md`
- Agent returns summary with context file path

Capture the context file path for use in next phases.

### Phase 3: Business Validation (Conditional)

If `$2` (Azure DevOps URL) is provided:

Use the Task tool to invoke `business-validator` agent:
- **Agent**: `business-validator`
- **Arguments**:
  - `$1`: Context file path
  - `$2`: Azure DevOps work item URL
- **Wait for completion**

Agent will:
- Fetch work item details from Azure DevOps
- Validate PR changes against acceptance criteria
- Append findings to context file

### Phase 4: Parallel Analysis

Invoke all analysis agents **in parallel** using a single message with multiple Task tool calls.

**IMPORTANT**: Use ONE message with MULTIPLE Task tool invocations for maximum efficiency.

Agents to invoke (all receive context file path as `$1`):
1. `performance-analyzer`
2. `architecture-reviewer`
3. `clean-code-auditor`
4. `security-scanner`
5. `testing-assessor`
6. `accessibility-checker`

Each agent will:
- Read context from file
- Perform specialized analysis
- Write report to: `.claude/sessions/pr_reviews/pr_{number}_{agent-name}_report.md`
- Return brief summary (< 200 words)

Do NOT wait for each agent individually - they run concurrently.

### Phase 5: Synthesis

After all agents complete, synthesize findings:

1. Read all agent reports from disk:
   ```bash
   ls .claude/sessions/pr_reviews/pr_{number}_*_report.md
   ```

2. Combine findings into unified review:
   - Group by severity (Critical, High, Medium, Low)
   - Eliminate duplicate findings across agents
   - Calculate overall score (average of agent scores)
   - Add executive summary

3. Create final review file:
   - Path: `.claude/sessions/pr_reviews/pr_{number}_final_review.md`
   - Format: Markdown with clear sections

4. Display summary to user:
   ```
   PR Review Complete for #123

   Overall Score: 7.2/10

   Critical Issues: 2
   High Priority: 5
   Medium Priority: 8
   Low Priority: 3

   Top Concerns:
   1. Infinite useEffect loop in useCart.ts (Performance)
   2. XSS vulnerability in SearchBar.tsx (Security)
   3. Missing tests for checkout flow (Testing)

   Full review: .claude/sessions/pr_reviews/pr_123_final_review.md
   ```

## Output

Generated files in `.claude/sessions/pr_reviews/`:
- `pr_{number}_context.md` - Raw PR data and metadata
- `pr_{number}_performance_report.md` - Performance analysis
- `pr_{number}_architecture_report.md` - Architecture review
- `pr_{number}_clean_code_report.md` - Code quality audit
- `pr_{number}_security_report.md` - Security scan
- `pr_{number}_testing_report.md` - Test assessment
- `pr_{number}_accessibility_report.md` - A11y check
- `pr_{number}_final_review.md` - Synthesized review

## Error Handling

### Missing PR Number
```
Error: PR number required

Usage: /review <PR_NUMBER> [AZURE_DEVOPS_URL]
Example: /review 123
```

### GitHub CLI Not Authenticated
```
Error: GitHub CLI not authenticated

To fix: gh auth login
Then retry: /review 123
```

### PR Not Found
```
Error: PR #123 not found

Verify:
1. PR number is correct
2. You have access to the repository
3. Try: gh pr view 123
```

### Agent Failure
If any agent fails:
- Log error to console
- Continue with other agents
- Mark failed agent in final report
- Don't block entire review

Example:
```
Warning: accessibility-checker failed (timeout)

Review continues with remaining agents.
Manual accessibility review recommended.
```

## Examples

Basic review:
```
/review 123
```

Review with business validation:
```
/review 123 https://dev.azure.com/org/project/_workitems/edit/456
```
```

---

## Context Gatherer Agent Example

An agent that collects and structures data for downstream analysis.

**File**: `.claude/agents/context-gatherer.md`

```yaml
---
name: context-gatherer
description: "Collects PR metadata, diffs, and CI status; creates structured context file"
tools: Bash(gh:*), Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Context Gatherer specializing in collecting and structuring GitHub PR data. Your responsibility is to create a comprehensive, well-organized context file that serves as the single source of truth for all downstream agents.
</role>

<specialization>
- GitHub API and CLI expertise
- PR metadata extraction
- Code diff collection and filtering
- Size-based adaptation strategies
- Structured markdown generation
</specialization>

<input>
This agent expects:
- `$1`: PR number (e.g., "123")

The agent will:
1. Use GitHub CLI to fetch PR data
2. Classify PR size
3. Collect relevant context
4. Create structured context file
</input>

<workflow>
### Step 1: Fetch PR Metadata

Use GitHub CLI to collect PR information:

```bash
gh pr view "$1" --json number,title,author,createdAt,updatedAt,state,mergeable,additions,deletions,changedFiles,baseRefName,headRefName,body,labels
```

Extract key fields:
- PR number and title
- Author and dates
- State and mergeable status
- Lines added/deleted
- Changed file count
- Base/head branches
- Description
- Labels

### Step 2: Classify PR Size

Calculate total lines changed: additions + deletions

Classify as:
- **Small**: < 200 lines → Full detailed review
- **Medium**: 200-500 lines → Focused analysis
- **Large**: 500-1000 lines → Strategic sampling
- **Very Large**: > 1000 lines → Risk-based review

Store classification for downstream agents.

### Step 3: Collect Changed Files

Get list of changed files:

```bash
gh pr view "$1" --json files --jq '.files[] | {path: .path, additions: .additions, deletions: .deletions, changes: .changes}'
```

For each file, record:
- File path
- Lines added
- Lines deleted
- Total changes

### Step 4: Fetch Code Diff (Adaptive)

**For Small/Medium PRs**:
```bash
gh pr diff "$1"
```
Collect complete diff.

**For Large/Very Large PRs**:
Use targeted approach - focus on critical patterns:
```bash
gh pr diff "$1" | grep -A 10 -B 3 "useEffect\|useState\|useMemo"
gh pr diff "$1" | grep -A 10 -B 3 "getStaticProps\|getServerSideProps"
gh pr diff "$1" | grep -A 10 -B 3 "dangerouslySetInnerHTML"
```

Collect:
- React hooks patterns
- Next.js data fetching
- Security-sensitive patterns
- Critical file changes

Document that partial diff was collected due to size.

### Step 5: Check CI Status

Fetch CI check runs:

```bash
gh pr checks "$1"
```

Record:
- Check names
- Status (passing/failing/pending)
- Conclusion

### Step 6: Create Structured Context File

Write to: `.claude/sessions/pr_reviews/pr_{number}_context.md`

Use this structure:

```markdown
# PR #{number} - Context

## PR Metadata
- **Title**: {title}
- **Author**: {author}
- **Created**: {createdAt}
- **Status**: {state}
- **Mergeable**: {mergeable}
- **Base Branch**: {baseRefName}
- **Head Branch**: {headRefName}

## Size Classification
- **Total Changes**: {additions + deletions} lines
- **Files Changed**: {changedFiles}
- **Classification**: {Small|Medium|Large|Very Large}
- **Review Strategy**: {Full|Focused|Strategic|Risk-based}

## Description
{body}

## Labels
- {label1}
- {label2}

## Changed Files

| File | +Lines | -Lines | Total |
|------|--------|--------|-------|
| {path} | {additions} | {deletions} | {changes} |

## Code Diff

{For Small/Medium: Full diff}
{For Large/Very Large: Filtered diff with note}

Note: This is a {Large|Very Large} PR. Diff filtered to focus on critical patterns:
- React hooks (useEffect, useState, useMemo, useCallback)
- Next.js data fetching (getStaticProps, getServerSideProps)
- Security patterns (dangerouslySetInnerHTML, eval, innerHTML)

For complete diff: `gh pr diff {number}`

## CI Status

| Check | Status | Conclusion |
|-------|--------|------------|
| {name} | {status} | {conclusion} |

## Analysis Notes

**Focus Areas** (based on file types):
- React components: {count} files
- TypeScript utilities: {count} files
- API routes: {count} files
- Configuration: {count} files

**Recommended Reviewers**:
- Performance: Focus on {list of relevant files}
- Security: Focus on {list of relevant files}
- Architecture: Focus on {list of relevant files}
- Testing: Check coverage for {list of relevant files}
```

### Step 7: Return Summary

Return concise summary to orchestrator:

```
Context gathered for PR #123

Classification: Medium (340 lines)
Changed files: 8
Critical areas: 3 React components, 2 API routes

Context file: .claude/sessions/pr_reviews/pr_123_context.md

Ready for parallel analysis.
```
</workflow>

<output_format>
**Context File Location**: `.claude/sessions/pr_reviews/pr_{number}_context.md`

**Summary Response** (< 200 words):
```
Context gathered for PR #{number}

Classification: {Small|Medium|Large|Very Large} ({lines} lines)
Changed files: {count}
Critical areas: {summary of file types}

Context file: {path}

Ready for parallel analysis.
```
</output_format>

<error_handling>
### PR Not Found
```bash
gh pr view "$1"
# Exit code 1: PR doesn't exist
```

**Response**:
```
Error: PR #123 not found

Possible causes:
1. PR number incorrect
2. No repository found in current directory
3. No access to repository

Verify:
- Current directory is a git repository
- PR exists: gh pr list
- You're authenticated: gh auth status
```

### GitHub CLI Not Authenticated
```bash
gh auth status
# Exit code 1: Not authenticated
```

**Response**:
```
Error: GitHub CLI not authenticated

To fix: gh auth login

After authentication, retry: /review 123
```

### Network/API Errors
If `gh` commands fail:
- Log specific error from gh CLI
- Suggest checking internet connection
- Recommend verifying repository access
- Provide manual fallback: direct GitHub URL

### Large Diff Handling
If diff exceeds reasonable size (> 10,000 lines):
- Use aggressive filtering
- Focus only on critical patterns
- Document limitation in context file
- Recommend PR split to user
</error_handling>
```

---

## Analyzer Agent Example

A specialized agent that performs focused analysis on specific aspects.

**File**: `.claude/agents/performance-analyzer.md`

```yaml
---
name: performance-analyzer
description: "Analyzes React/Next.js performance patterns, hooks, rendering, and bundle size"
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Performance Engineer specializing in React and Next.js optimization. Your responsibility is to identify performance bottlenecks, inefficient patterns, and opportunities for optimization in frontend code.
</role>

<specialization>
Focus areas:
- React hooks optimization (useEffect, useMemo, useCallback)
- Component rendering efficiency
- Next.js data fetching patterns
- Bundle size and code splitting
- Image optimization
- Runtime performance

Expertise in:
- React 18+ features and best practices
- Next.js 13+ App Router and Pages Router
- Performance profiling and metrics
- Web Vitals (LCP, FID, CLS, INP)
</specialization>

<input>
This agent expects:
- `$1`: Path to context file (e.g., `.claude/sessions/pr_reviews/pr_123_context.md`)

Context file contains:
- PR metadata
- Changed files list
- Code diffs (full or filtered)
- Size classification
</input>

<workflow>
### Step 1: Read Context

Read the context file at path `$1`:

```bash
# Agent will read: cat "$1"
```

Extract sections:
- Changed files list
- Code diffs
- Size classification

Filter for relevant files:
- `.tsx`, `.jsx`, `.ts`, `.js` files
- Focus on components, pages, hooks
- Prioritize files in `components/`, `pages/`, `app/`, `hooks/`

### Step 2: Pattern Analysis - React Hooks

Scan for common hook anti-patterns:

**useEffect Issues**:
```typescript
// ❌ Infinite loop
useEffect(() => {
  setCount(count + 1);
}, [count]);

// ❌ Missing dependencies
useEffect(() => {
  fetchData(userId);
}, []); // userId missing

// ❌ Expensive operations
useEffect(() => {
  const result = expensiveCalculation(data);
  setResult(result);
}, [data]);
```

**useMemo Issues**:
```typescript
// ❌ Premature optimization
const value = useMemo(() => x + y, [x, y]); // Too simple

// ❌ Missing dependencies
const filtered = useMemo(() => {
  return items.filter(item => item.category === category);
}, [items]); // category missing
```

**useCallback Issues**:
```typescript
// ❌ Unnecessary useCallback
const handleClick = useCallback(() => {
  console.log('clicked');
}, []); // No dependencies, no need for useCallback
```

Use grep to find patterns:
```bash
grep -n "useEffect\|useMemo\|useCallback" {file}
```

### Step 3: Pattern Analysis - Component Optimization

Check for missing memoization:

```typescript
// ❌ No memoization on expensive component
const ExpensiveList = ({ items, filter }) => {
  return items.filter(filter).map(item => <Item key={item.id} {...item} />);
};

// ✅ With memoization
const ExpensiveList = memo(({ items, filter }) => {
  const filtered = useMemo(() => items.filter(filter), [items, filter]);
  return filtered.map(item => <Item key={item.id} {...item} />);
});
```

Look for:
- Large lists without virtualization
- Components without `memo()` that receive object props
- Expensive computations in render
- Inline function definitions in props

### Step 4: Pattern Analysis - Next.js

**Data Fetching**:
```typescript
// ❌ Client-side fetching for static data
useEffect(() => {
  fetch('/api/data').then(setData);
}, []);

// ✅ Static generation
export async function getStaticProps() {
  const data = await fetch('/api/data');
  return { props: { data } };
}
```

**Code Splitting**:
```typescript
// ❌ Heavy import without splitting
import HugeLibrary from 'huge-library';

// ✅ Dynamic import
const HugeLibrary = dynamic(() => import('huge-library'), {
  loading: () => <Spinner />
});
```

**Image Optimization**:
```typescript
// ❌ Unoptimized image
<img src="/hero.jpg" />

// ✅ Next.js Image
<Image src="/hero.jpg" width={800} height={600} alt="Hero" />
```

### Step 5: Bundle Size Analysis

Check package.json for heavy dependencies:

```bash
# Read package.json from diff
grep -A 50 "package.json" "$1"
```

Flag additions of:
- moment.js (suggest date-fns or native Intl)
- lodash (suggest lodash-es or individual imports)
- Large UI libraries without tree shaking

### Step 6: Scoring

Start at 10/10 (perfect) and deduct:

**Critical (P0)**: -3 to -5 points
- Infinite useEffect loops
- Memory leaks
- Blocking main thread (heavy sync operations)

**High (P1)**: -1 to -2 points
- Missing React.memo on expensive components
- Unnecessary re-renders
- Unoptimized images
- Missing code splitting for large imports

**Medium (P2)**: -0.5 to -1 points
- Missing useMemo for expensive calculations
- Suboptimal data fetching patterns
- Minor bundle size increases

**Low (P3)**: -0.25 to -0.5 points
- Premature optimization (over-use of useMemo)
- Minor code organization issues

**Credits**: +0.5 to +1 points
- Excellent use of React.memo
- Proper code splitting
- Optimized images
- Good data fetching patterns

Minimum score: 1/10

### Step 7: Generate Report

Write report to: `.claude/sessions/pr_reviews/pr_{number}_performance_report.md`

Structure:

```markdown
# Performance Analysis - PR #{number}

## Executive Summary

{3-5 sentences summarizing findings, score, and key issues}

Score: {X}/10

## Critical Issues (P0)

### Issue 1: Infinite useEffect Loop

**File**: `src/hooks/useCart.ts:23-27`
**Severity**: Critical (P0)
**Impact**: Component re-renders infinitely, causing browser freeze and poor UX

**Current Code**:
```typescript
useEffect(() => {
  setCount(count + 1);
}, [count]); // ❌ Creates infinite loop
```

**Fix**:
```typescript
// Option 1: Functional update
useEffect(() => {
  setCount(prevCount => prevCount + 1);
}, []); // ✅ Runs once

// Option 2: Remove if unnecessary
// If incrementing on every render isn't needed, remove useEffect
```

**Testing**:
1. Add React DevTools Profiler
2. Verify component doesn't re-render infinitely
3. Check console for warnings

**Priority**: Must fix before merge

## High Priority Issues (P1)

### Issue 2: Missing Memoization on Expensive Component

**File**: `src/components/ProductList.tsx:15-45`
**Severity**: High (P1)
**Impact**: Re-renders 500+ items unnecessarily on every parent update

**Current Code**:
```typescript
const ProductList = ({ products, onSelect }) => {
  return products.map(product => (
    <ProductCard key={product.id} product={product} onClick={onSelect} />
  ));
};
```

**Fix**:
```typescript
import { memo, useMemo, useCallback } from 'react';

const ProductList = memo(({ products, onSelect }) => {
  // Memoize expensive filtering/sorting if any
  const processedProducts = useMemo(() => {
    return products; // or apply transformations
  }, [products]);

  return processedProducts.map(product => (
    <ProductCard
      key={product.id}
      product={product}
      onClick={onSelect}
    />
  ));
});

// Also memoize ProductCard if it's expensive
const ProductCard = memo(({ product, onClick }) => {
  const handleClick = useCallback(() => {
    onClick(product.id);
  }, [onClick, product.id]);

  return <div onClick={handleClick}>{product.name}</div>;
});
```

**Testing**:
1. Use React DevTools Profiler
2. Update parent component
3. Verify ProductList doesn't re-render if products unchanged

**Priority**: Should fix before merge

## Medium Priority Issues (P2)

{Similar structure}

## Low Priority Issues (P3)

{Similar structure}

## Best Practices Observed

- ✅ Good use of dynamic imports in src/pages/dashboard.tsx
- ✅ Proper Next.js Image component usage in hero section
- ✅ Effective use of React.memo in Button component

## Recommendations

1. **Immediate**:
   - Fix infinite useEffect loop (P0)
   - Add memoization to ProductList (P1)

2. **Before Merge**:
   - Optimize remaining unoptimized images
   - Add code splitting for dashboard components

3. **Future**:
   - Consider virtualizing long lists (react-window)
   - Implement progressive loading for images
   - Add performance monitoring (Web Vitals)

## Performance Metrics Estimate

Based on changes:
- **Bundle Size**: +45 KB (dependencies added)
- **Render Count**: Reduced by 60% with memoization fixes
- **LCP Impact**: Minimal (no large images added)

## Score Breakdown

Starting score: 10/10

**Deductions**:
- Infinite useEffect loop: -4 (Critical)
- Missing memoization: -1.5 (High)
- Unoptimized image: -0.5 (Medium)

**Credits**:
- Good dynamic imports: +0.5
- Proper Image usage: +0.5

**Final Score**: 10 - 4 - 1.5 - 0.5 + 0.5 + 0.5 = **5.5/10**

**Verdict**: Fair - Performance issues need attention before merge. Critical useEffect loop must be fixed.
```

### Step 8: Return Summary

Return concise summary to orchestrator (< 200 words):

```
Performance analysis complete for PR #123.

Score: 5.5/10 (Fair)

Critical Issues (P0): 1
- Infinite useEffect loop in useCart.ts (browser freeze risk)

High Priority (P1): 3
- Missing memoization on ProductList (unnecessary re-renders)
- Unoptimized code splitting for Dashboard
- Large bundle size increase (+45 KB)

Medium Priority (P2): 5
Low Priority (P3): 2

Positive findings:
- Good use of dynamic imports
- Proper Next.js Image component usage

Recommendations:
1. Fix infinite loop immediately (blocking issue)
2. Add memoization to ProductList before merge
3. Consider virtualizing large lists

Full report: .claude/sessions/pr_reviews/pr_123_performance_report.md
```
</workflow>

<output_format>
**Report File**: `.claude/sessions/pr_reviews/pr_{number}_performance_report.md`

**Summary Response** (< 200 words):
```
Performance analysis complete for PR #{number}.

Score: {X}/10 ({Excellent|Good|Fair|Poor|Critical})

Critical Issues (P0): {count}
{Top 1-2 critical issues}

High Priority (P1): {count}
{Top 1-2 high issues}

Positive findings:
{1-2 best practices observed}

Recommendations:
1. {Top recommendation}
2. {Second recommendation}

Full report: {file path}
```
</output_format>

<error_handling>
### No React/Next.js Files

If no relevant files found in diff:

```
No React or Next.js files detected in this PR.

Files analyzed: {count}
Relevant extensions: .tsx, .jsx, .ts, .js
Found: 0

Performance analysis skipped.

Report: .claude/sessions/pr_reviews/pr_{number}_performance_report.md
(Report includes "No relevant changes" note)
```

### Context File Missing

If `$1` file doesn't exist:

```
Error: Context file not found at {$1}

This usually means context-gatherer hasn't run yet.

To fix:
1. Ensure /review command is running correctly
2. Check context-gatherer agent completed
3. Verify file exists: ls .claude/sessions/pr_reviews/
```

### Very Large PR

If PR > 1000 lines:

```
Note: Large PR detected (1500 lines)

Performance analysis focused on:
- Critical hook patterns
- Major component changes
- New dependencies

For comprehensive review:
1. Consider splitting PR
2. Run: gh pr diff {number} | grep "useEffect"
3. Manual review recommended for {large files}
```

In report, document sampling strategy used.
</error_handling>

<best_practices>
**React Hooks Guidelines**:
- useEffect: Always include all dependencies
- useMemo: Use for expensive calculations, not simple operations
- useCallback: Use when passing callbacks to memoized children

**Component Guidelines**:
- Use React.memo for components with expensive renders
- Avoid inline function definitions in props of memoized components
- Consider virtualization for lists > 100 items

**Next.js Guidelines**:
- Prefer getStaticProps/getServerSideProps over client fetching
- Use next/image for all images > 10 KB
- Use dynamic imports for components > 50 KB
- Enable experimental.optimizePackageImports when available

**Bundle Size Guidelines**:
- Flag dependency additions > 20 KB
- Suggest lightweight alternatives
- Check for tree shaking support

**Web Vitals Focus**:
- LCP: Image optimization, critical CSS
- FID/INP: Reduce JavaScript, defer non-critical code
- CLS: Proper sizing for images and ads
</best_practices>
```

---

## Complete Plugin Example

Minimal but complete plugin structure for a focused use case.

**Use Case**: Git commit message helper plugin

### File Structure

```
commit-helper-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── commit-msg.md
├── agents/
│   └── message-generator.md
└── README.md
```

### plugin.json

```json
{
  "name": "commit-helper",
  "version": "1.0.0",
  "description": "Generate clear, conventional commit messages from staged changes",
  "author": "Your Name",
  "repository": "github.com/username/commit-helper-plugin",
  "commands": [
    {
      "name": "commit-msg",
      "description": "Generate commit message from staged changes"
    }
  ],
  "agents": [
    "message-generator"
  ],
  "dependencies": {
    "git": "Git version control required"
  }
}
```

### commands/commit-msg.md

```yaml
---
description: "Generate conventional commit message from git staged changes"
---

# Generate Commit Message

Analyzes staged git changes and generates a clear, conventional commit message.

## Prerequisites

- Git repository
- Staged changes: `git add <files>`

## Usage

```bash
# Stage your changes
git add src/components/Button.tsx
git add src/utils/helpers.ts

# Generate commit message
/commit-msg
```

## Workflow

### Step 1: Verify Git Repository

```bash
git rev-parse --git-dir
```

If not a git repo:
```
Error: Not a git repository

Initialize with: git init
```

### Step 2: Check for Staged Changes

```bash
git diff --staged
```

If no changes staged:
```
Error: No staged changes detected

Stage changes with: git add <files>
Then retry: /commit-msg
```

### Step 3: Invoke Message Generator

Use the Task tool to invoke `message-generator` agent.

Agent will:
1. Analyze staged diff
2. Identify change type
3. Generate conventional commit message
4. Return message to user

### Step 4: Display Message

Show generated message with option to commit:

```
Generated commit message:

feat(button): add loading state and spinner

- Add isLoading prop to Button component
- Implement spinner animation
- Update Button stories with loading example

To commit with this message:
git commit -m "feat(button): add loading state and spinner

- Add isLoading prop to Button component
- Implement spinner animation
- Update Button stories with loading example"

Or review and edit as needed.
```

## Conventional Commits Format

Messages follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, missing semi-colons)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Build process or auxiliary tool changes

## Examples

**Feature**:
```
feat(auth): add social login support

- Integrate OAuth with Google and GitHub
- Add social login buttons to login page
- Store social auth tokens in secure storage
```

**Bug Fix**:
```
fix(cart): prevent duplicate items in cart

Fixes issue where clicking "Add to Cart" rapidly
would add multiple copies of the same item.
```

**Refactor**:
```
refactor(api): simplify error handling

Extract error handling logic into separate module
for better reusability and testing.
```
```

### agents/message-generator.md

```yaml
---
name: message-generator
description: "Generates conventional commit message from git staged changes"
tools: Bash(git:*)
model: claude-sonnet-4-5-20250929
---

<role>
You are a Commit Message Expert who generates clear, conventional commit messages following industry best practices.
</role>

<workflow>
### Step 1: Get Staged Diff

```bash
git diff --staged
```

Analyze:
- Which files changed
- What kind of changes (additions, modifications, deletions)
- Scope of changes

### Step 2: Identify Change Type

Based on diff, determine type:
- **feat**: New functionality added
- **fix**: Bug fixed
- **refactor**: Code restructured without behavior change
- **perf**: Performance improved
- **docs**: Documentation only
- **style**: Formatting/style only
- **test**: Tests added/modified
- **chore**: Build/config changes

### Step 3: Determine Scope

Identify affected area from file paths:
- `src/components/Button.tsx` → scope: `button`
- `src/pages/checkout/` → scope: `checkout`
- `docs/API.md` → scope: `docs`
- Multiple areas → use general scope or omit

### Step 4: Write Subject

Create concise subject (50 chars or less):
- Start with lowercase verb
- No period at end
- Be specific but brief

Examples:
- ✅ `add loading state to button`
- ✅ `fix duplicate items in cart`
- ❌ `Added new feature` (past tense, vague)
- ❌ `Fix bug.` (unnecessary period)

### Step 5: Write Body

List key changes as bullet points:
- What was changed
- Why (if not obvious)
- Keep lines under 72 characters

### Step 6: Add Footer (if needed)

Include:
- Breaking changes: `BREAKING CHANGE: ...`
- Issue references: `Fixes #123` or `Closes #456`

### Step 7: Return Message

Return complete conventional commit message:

```
{type}({scope}): {subject}

{body}

{footer}
```
</workflow>

<output_format>
```
Generated commit message:

{type}({scope}): {subject}

{body bullet points}

{footer if applicable}
```

Example:
```
Generated commit message:

feat(button): add loading state and spinner

- Add isLoading prop to Button component
- Implement CSS spinner animation
- Update TypeScript types for new prop
- Add loading example to Storybook

To commit: git commit -m "feat(button): add loading state and spinner

- Add isLoading prop to Button component
- Implement CSS spinner animation
- Update TypeScript types for new prop
- Add loading example to Storybook"
```
</output_format>

<error_handling>
### No Staged Changes
```
No staged changes detected.

To stage changes: git add <file>
To see unstaged changes: git status
```

### Too Many Changes
If > 20 files changed:
```
Warning: Large changeset detected (25 files)

Consider splitting into smaller commits:
1. Group related changes: git add src/feature-a/
2. Commit: git commit
3. Repeat for other groups

Current message will be generic due to scope.
```

Generate generic message like:
```
feat(multiple): implement user authentication flow

- Add login and signup components
- Implement JWT token handling
- Update API client with auth headers
[... abbreviated due to large changeset]

Total files changed: 25
Consider reviewing individual changes.
```
</error_handling>

<best_practices>
**Subject Line**:
- Use imperative mood ("add" not "added")
- Lowercase first word
- No period at end
- 50 characters or less

**Body**:
- Separate from subject with blank line
- Wrap at 72 characters
- Use bullet points for multiple changes
- Explain WHAT and WHY, not HOW

**Type Selection**:
- Use `feat` for user-facing new functionality
- Use `fix` for user-facing bug fixes
- Use `chore` for internal changes
- Use `refactor` only when no behavior changes

**Scope**:
- Use component/module name
- Be consistent across commits
- Omit if change is global

**Breaking Changes**:
- Always document in footer
- Explain migration path
- Reference docs if available
</best_practices>
```

### README.md

```markdown
# Commit Helper Plugin

Generate clear, conventional commit messages from your staged changes.

## Installation

```bash
/plugin marketplace add username/marketplace-name
/plugin install commit-helper@marketplace-name
```

## Quick Start

```bash
# Stage your changes
git add src/components/Button.tsx

# Generate commit message
/commit-msg
```

## Features

- Analyzes git staged changes
- Generates conventional commit messages
- Follows industry standards (Conventional Commits)
- Suggests appropriate type, scope, and body

## Commands

### /commit-msg

Generates a commit message from your staged changes.

**Usage**:
```bash
# After staging changes
git add .
/commit-msg
```

**Output**:
```
Generated commit message:

feat(button): add loading state and spinner

- Add isLoading prop to Button component
- Implement spinner animation
- Update Button stories with loading example
```

## Conventional Commits

Messages follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature for user
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting
- `refactor`: Code restructuring
- `perf`: Performance improvements
- `test`: Testing
- `chore`: Build/tooling changes

## Examples

**Adding a feature**:
```bash
git add src/components/SearchBar.tsx
/commit-msg
# → feat(search): add autocomplete functionality
```

**Fixing a bug**:
```bash
git add src/utils/formatPrice.ts
/commit-msg
# → fix(utils): handle negative prices correctly
```

**Refactoring**:
```bash
git add src/api/client.ts
/commit-msg
# → refactor(api): extract error handling to separate module
```

## Best Practices

1. **Stage related changes together**: Don't mix unrelated changes in one commit
2. **Keep commits focused**: One logical change per commit
3. **Review generated message**: Edit if needed to add context
4. **Use consistent scopes**: Maintain same scope names across commits

## Troubleshooting

### "No staged changes detected"

**Solution**: Stage changes first
```bash
git add <files>
/commit-msg
```

### "Not a git repository"

**Solution**: Initialize git repository
```bash
git init
git add .
/commit-msg
```

## License

MIT
```

---

## Token Optimization Example

Before and after comparison showing dramatic token reduction.

### Before Optimization

**Agent prompt** (verbose, ~3000 words):

```yaml
---
name: performance-analyzer
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

You are a performance analyzer specializing in React and Next.js applications. Your job is to review code changes in pull requests and identify performance issues, anti-patterns, and optimization opportunities.

When analyzing a PR, you should look for the following issues:

1. React Hooks Issues:
   - useEffect with missing dependencies: When useEffect is used but doesn't include all values from the component scope that are used inside the effect, it can lead to bugs. For example:
   ```typescript
   useEffect(() => {
     fetchData(userId);
   }, []); // userId is missing from dependencies
   ```
   This is wrong because userId is used but not in the dependency array.

   - useEffect creating infinite loops: When useEffect updates state that's in its dependency array:
   ```typescript
   useEffect(() => {
     setCount(count + 1);
   }, [count]); // This creates infinite loop
   ```

   - Expensive operations in useEffect without cleanup: When expensive operations run in useEffect...

   [... continues for 2000+ more words with extensive examples and explanations ...]

To analyze a PR:
1. First, you'll receive the PR context
2. Then, you should read the context carefully
3. Next, identify all React and Next.js files
4. After that, scan each file for the patterns listed above
5. Then, collect your findings
6. Next, score based on severity
7. After scoring, write a detailed report
8. Finally, return a summary

Remember to be thorough and check every file. Make sure you don't miss any issues. Review carefully and provide detailed explanations for each finding.

[... more verbose instructions ...]
```

**Token cost**: ~4,000 tokens for system prompt alone

### After Optimization

**Agent prompt** (concise, ~600 words):

```yaml
---
name: performance-analyzer
description: "Analyzes React/Next.js performance patterns, hooks, rendering, and bundle size"
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
Performance Engineer specializing in React and Next.js optimization. Identify bottlenecks, inefficient patterns, and optimization opportunities.
</role>

<specialization>
- React hooks (useEffect, useMemo, useCallback)
- Component rendering and memoization
- Next.js data fetching
- Bundle size and code splitting
</specialization>

<input>
- `$1`: Path to context file
</input>

<workflow>
### Step 1: Read Context
Read file at `$1`, extract React/Next.js file changes.

### Step 2: Scan Patterns

**Hooks**:
```typescript
// ❌ Infinite loop
useEffect(() => setCount(count + 1), [count]);

// ✅ Fixed
useEffect(() => setCount(c => c + 1), []);
```

**Memoization**:
```typescript
// ❌ Missing memo
const List = ({ items }) => items.map(i => <Item {...i} />);

// ✅ With memo
const List = memo(({ items }) => items.map(i => <Item {...i} />));
```

### Step 3: Score
Start 10/10, deduct:
- Critical: -3 to -5
- High: -1 to -2
- Medium: -0.5 to -1

### Step 4: Report
Write to: `.claude/sessions/pr_reviews/pr_{number}_performance_report.md`

Return summary < 200 words.
</workflow>

<output_format>
## Executive Summary
{3-5 sentences, score}

## Findings
### Issue: {Title}
- **File**: path:line
- **Severity**: Critical/High/Medium/Low
- **Impact**: {description}
- **Fix**: {code example}

## Score: X/10
{Rationale}
</output_format>

<error_handling>
- No relevant files: Report "No React/Next.js changes"
- Context missing: Suggest running context-gatherer
- Large PR: Focus on critical patterns, document limitation
</error_handling>
```

**Supporting file**: `PATTERNS.md` (referenced when needed)

```markdown
# React Performance Patterns

## useEffect Anti-Patterns

### Infinite Loops
```typescript
// ❌ Creates infinite re-render
useEffect(() => {
  setCount(count + 1);
}, [count]);

// ✅ Use functional update
useEffect(() => {
  setCount(c => c + 1);
}, []);
```

### Missing Dependencies
```typescript
// ❌ Stale closure
useEffect(() => {
  fetchData(userId);
}, []); // userId missing

// ✅ Include all dependencies
useEffect(() => {
  fetchData(userId);
}, [userId]);
```

[... more detailed examples only loaded when agent references this file ...]
```

**Token cost after optimization**:
- System prompt: ~800 tokens (80% reduction)
- PATTERNS.md loaded only when needed: ~500 tokens
- Total typical use: ~1,300 tokens (67% reduction)

### Key Optimization Techniques Used

1. **XML structure** (`<role>`, `<workflow>`) - Clear sections without verbose headers
2. **Concise examples** - One good/bad pair instead of 10 variations
3. **Progressive disclosure** - Detailed patterns in separate file
4. **Remove redundancy** - "Then", "Next", "After that" removed
5. **Imperative instructions** - Direct commands vs explanatory prose
6. **Code over words** - Show pattern in code, not 3 paragraphs of explanation

---

## Summary

These examples demonstrate:

1. **Simple commands** for single tasks (setup)
2. **Orchestrator commands** for multi-agent workflows (review)
3. **Context gatherers** that establish data foundation
4. **Analyzers** that perform specialized inspection
5. **Complete plugins** with all components integrated
6. **Token optimization** achieving 60-70% reduction

Use these patterns as templates for your own plugin development.
