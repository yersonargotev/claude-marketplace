---
description: "Performs a comprehensive technical PR review using a suite of specialized sub-agents."
argument-hint: "<PR_URL> [HU_URL_1] [HU_URL_2]..."
---

# Comprehensive PR Review

Your task is to act as a lead technical reviewer and orchestrate a full PR review for PR `$1`.

### Step 1: Gather Context
Invoke the `context-gatherer` sub-agent for PR `$1` to get all the necessary metadata, file changes, and diffs. This context is essential for all subsequent steps.

### Step 2: Validate Business Requirements (Conditional)
If Azure DevOps URLs are provided (as `$2`, `$3`, etc.), invoke the `business-validator` sub-agent. Provide it with the context from Step 1 and the list of URLs.

### Step 3: Delegate Code Analysis
In parallel, delegate the code analysis to the following specialized sub-agents, providing each with the context from Step 1:
- `performance-analyzer`
- `architecture-reviewer`
- `clean-code-auditor`
- `security-scanner`
- `testing-assessor`
- `accessibility-checker`

### Step 4: Synthesize the Final Report
Once all sub-agents have completed their analysis, synthesize their individual reports into a single, comprehensive review document. Use the following structure:

1.  **Executive Summary**: PR overview, overall quality score, and final recommendation.
2.  **Business Context Validation**: (if applicable) Report from the `business-validator`.
3.  **Performance Analysis**: Report from the `performance-analyzer`.
4.  **Design & Architecture**: Report from the `architecture-reviewer`.
5.  **Clean Code Analysis**: Report from the `clean-code-auditor`.
6.  **Security Assessment**: Report from the `security-scanner`.
7.  **Testing & Quality**: Report from the `testing-assessor`.
8.  **Accessibility Assessment**: Report from the `accessibility-checker`.
9.  **Action Plan**: Consolidate all findings into a prioritized list of actions (Must Fix, Should Fix, Nice to Have).
10. **Best Practices Recognition**: Highlight positive aspects from all reports.

Your final output should be a single, easy-to-read markdown document that provides a 360-degree view of the PR's quality.