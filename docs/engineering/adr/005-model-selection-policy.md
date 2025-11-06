# ADR 005: Model Selection Policy

**Status**: Accepted  
**Date**: November 6, 2025

## Context

Different tasks require different capability/speed trade-offs. Using Sonnet for trivial tasks wastes resources; using Haiku for architecture wastes quality.

## Decision

**Explicit model specification** in agent frontmatter with clear policy:

| Context | Model | Reasoning |
|---------|-------|-----------|
| **Default** | `claude-sonnet-4-5-20250929` | Balance |
| **Fast ops** | `haiku` | Simple research, quick fixes |
| **Deep thinking** | `opus` or extended sonnet | Architecture, critical decisions |

**Rules**:
1. Agents ALWAYS specify model explicitly (no inheritance)
2. Commands override only when needed (`/patch` uses haiku)
3. Extended thinking (`think`, `ULTRATHINK`) is preferred over model changes for complexity

## Implementation

**Fast Command** (`/patch`):
```yaml
<Task agent="investigator" model="haiku">
```

**Default** (most agents):
```yaml
model: claude-sonnet-4-5-20250929
```

**Deep Thinking** (`architect` for complex tasks):
```markdown
Use ULTRATHINK for VERY_LARGE tasks (not opus)
```

## Results

- Predictable performance
- Cost optimization for trivial tasks
- Quality maintained for critical work

## Related

- [ADR-002](./002-adaptive-research-depth.md) - Research depth matching

