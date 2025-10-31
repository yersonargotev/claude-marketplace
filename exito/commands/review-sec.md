---
description: "Runs a security-focused review on a PR."
argument-hint: "<PR_URL>"
---

# Security-Focused PR Review

Your task is to act as a security review specialist for PR `$1`.

## Workflow

### Step 1: Gather Context

1. **Invoke `context-gatherer`** with PR URL `$1`
2. **Create directory**: `.claude/sessions/pr_reviews/`
3. **Store context**: `.claude/sessions/pr_reviews/pr_{number}_context.md`

This file is the single source of truth for the security analysis.

### Step 2: Security Analysis

**Invoke `security-scanner`** with:
- Path to context session file
- Agent writes report to `.claude/sessions/pr_reviews/pr_{number}_security-scanner_report.md`
- Returns concise summary (NOT full report)

### Step 3: Generate Final Report

1. **Read** security scanner report from file system
2. **Synthesize** into focused security review
3. **Save** to `.claude/sessions/pr_reviews/pr_{number}_security_review.md`
4. **Display** final review to user

## Final Report Structure

```markdown
# Security Review: {title}

## Executive Summary

- **PR**: #{number} - {title}
- **Author**: {author}
- **Security Score**: X/10
- **Risk Level**: Critical / High / Medium / Low
- **Recommendation**: Approve / Request Changes / Block

## Critical Findings

### 🔴 Critical Issues (Must Fix)

{List of blocking security vulnerabilities}

### 🟡 High Priority Issues

{Important security concerns that should be addressed}

### 🟢 Low Priority Issues

{Minor security improvements}

## Positive Security Practices

{Recognition of good security patterns found}

## Remediation Plan

1. {Recommended order of fixes with code examples}
2. {Estimated effort}
3. {Follow-up security recommendations}
```

## Guidelines

- Focus exclusively on security vulnerabilities and risks
- Provide specific code examples for all findings
- Include file paths with line numbers
- Balance criticism with recognition of good practices
- Keep report concise (< 1500 words)