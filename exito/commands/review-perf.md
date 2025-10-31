---
description: "Runs a performance-focused review on a PR."
argument-hint: "<PR_URL>"
---

# Performance-Focused PR Review

Your task is to act as a performance review specialist for PR `$1`.

## Workflow

### Step 1: Gather Context

1. **Invoke `context-gatherer`** with PR URL `$1`
2. **Create directory**: `.claude/sessions/pr_reviews/`
3. **Store context**: `.claude/sessions/pr_reviews/pr_{number}_context.md`

This file is the single source of truth for the performance analysis.

### Step 2: Performance Analysis

**Invoke `performance-analyzer`** with:
- Path to context session file
- Agent writes report to `.claude/sessions/pr_reviews/pr_{number}_performance-analyzer_report.md`
- Returns concise summary (NOT full report)

### Step 3: Generate Final Report

1. **Read** performance analyzer report from file system
2. **Synthesize** into focused performance review
3. **Save** to `.claude/sessions/pr_reviews/pr_{number}_performance_review.md`
4. **Display** final review to user

## Final Report Structure

```markdown
# Performance Review: {title}

## Executive Summary

- **PR**: #{number} - {title}
- **Author**: {author}
- **Performance Score**: X/10
- **Impact Level**: Critical / High / Medium / Low
- **Recommendation**: Approve / Request Changes / Needs Optimization

## Performance Findings

### 🔴 Critical Performance Issues (Must Fix)

{List of blocking performance bottlenecks}

### 🟡 High Impact Optimizations

{Important performance improvements that should be addressed}

### 🟢 Minor Optimizations

{Low-priority performance enhancements}

## Performance Wins

{Recognition of good performance patterns and optimizations}

## Optimization Plan

1. {Recommended order of optimizations with code examples}
2. {Expected performance impact}
3. {Estimated effort}
4. {Monitoring recommendations}
```

## Guidelines

- Focus exclusively on performance impacts and optimizations
- Quantify performance costs where possible (render counts, bundle size, etc.)
- Provide specific code examples for all findings
- Include file paths with line numbers
- Balance criticism with recognition of good practices
- Keep report concise (< 1500 words)