# ADR 002: Adaptive Research Depth

**Status**: Accepted  
**Date**: November 6, 2025

## Context

Not all tasks require deep research. A trivial color change shouldn't consume the same tokens as a complete architecture redesign.

## Decision

Implement adaptive research depth in `investigator` agent with automatic task classification (TRIVIAL → VERY_LARGE) and context mode hints from commands.

## Implementation

**Task Classification**:
- TRIVIAL: < 50 lines, 1-2 files → 5-10 min, 5K-10K tokens
- SMALL: < 200 lines, < 5 files → 10-15 min, 10K-20K tokens
- MEDIUM: 200-500 lines, 5-10 files → 15-20 min, 20K-35K tokens
- LARGE: 500-1000 lines, 10-20 files → 20-30 min, 35K-50K tokens
- VERY_LARGE: > 1000 lines, > 20 files → 30-40 min, 50K-80K tokens

**Context Modes**:
- `fast-mode`: Quick lookup for `/patch`
- `standard`: Balanced for `/build`
- `deep-research`: Exhaustive for `/think`
- `frontend-focus`: UI-specific for `/ui`

## Results

- **10K-30K tokens saved** on trivial tasks
- Optimal resource allocation
- Same quality for complex tasks

## Related

- [ADR-001](./001-file-based-context-sharing.md) - What gets written to files
- [ADR-005](./005-model-selection-policy.md) - Model choice per complexity

