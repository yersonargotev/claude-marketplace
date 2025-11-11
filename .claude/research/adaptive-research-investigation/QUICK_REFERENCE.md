# Adaptive Research System - Quick Reference

**Last Updated**: 2025-11-05

## TL;DR

Create intelligent research commands/agents that automatically choose the right research strategy based on task type:

- **Fixes** → Local codebase analysis
- **Features** → Local patterns + Online best practices (Hybrid)
- **Refactors** → Local structure + Online approaches (Hybrid)
- **Docs/Chores** → Local only

**Token savings**: 60-70% through file-based context sharing

---

## Task Classification Matrix

```
Task Type + Complexity → Research Strategy

feat (any size)           → HYBRID (local + online)
fix (small/medium)        → LOCAL (codebase only)
fix (large)               → HYBRID
refactor (medium+)        → HYBRID
perf (small+)             → HYBRID
docs/test (any)           → LOCAL
style/chore (any)         → LOCAL
build/ci (medium+)        → HYBRID
```

---

## Research Depth Levels

| Complexity | Context Mode | Time | Tokens | Use Case |
|------------|--------------|------|--------|----------|
| Trivial | `fast-mode` | 5-10 min | 5K-15K | Simple fixes |
| Small | `fast-mode` or `standard` | 10-15 min | 10K-20K | Small features |
| Medium | `standard` | 15-20 min | 20K-35K | Standard features |
| Large | `workflow-analysis` | 20-30 min | 35K-50K | Complex work |
| Very Large | `deep-research` | 30-40 min | 50K-80K | Critical/architectural |

---

## Agent Architecture

```
Task Classifier
    ↓
┌───────┬───────┬────────┐
│ Local │Online │ Hybrid │
└───┬───┴───┬───┴────┬───┘
    │       │        │
    └───────┴────────┘
            ↓
    Synthesis Agent
```

---

## Key Agents to Create

### 1. task-classifier
- **Purpose**: Analyze task → determine type, complexity, strategy
- **Tools**: None (pure reasoning)
- **Output**: Classification + routing instructions

### 2. local-researcher
- **Purpose**: Codebase analysis only
- **Tools**: Read, Grep, Glob, Bash(git/gh)
- **Output**: Local patterns, conventions, context

### 3. online-researcher
- **Purpose**: Web research for best practices
- **Tools**: WebSearch, WebFetch
- **Output**: Current approaches, documentation, recommendations

### 4. hybrid-researcher
- **Purpose**: Orchestrate local + online, synthesize
- **Tools**: Task, Read, Write
- **Output**: Unified context combining both sources

---

## Implementation Phases

### Phase 1: Foundation (Week 1)
- [ ] Create task-classifier agent
- [ ] Enhance investigator with task type awareness
- [ ] Test classification with 20+ examples

### Phase 2: Specialized Researchers (Week 2)
- [ ] Create local-researcher agent
- [ ] Create online-researcher agent
- [ ] Create hybrid-researcher agent
- [ ] Test each independently

### Phase 3: Task-Specific Commands (Week 3)
- [ ] Create /research-feat, /research-fix, /research-refactor
- [ ] Update /build, /workflow, /implement
- [ ] Add documentation

### Phase 4: Optimization (Week 4)
- [ ] Monitor token usage
- [ ] Implement caching
- [ ] Performance tuning

---

## Example Usage

### Automatic Classification
```bash
# User runs:
/research Add JWT authentication

# System:
1. Task Classifier → Type: feat, Complexity: medium, Strategy: hybrid
2. Hybrid Researcher → Local patterns + Online JWT best practices
3. Output: Unified context with recommendations
```

### Task-Specific Commands
```bash
# For features (always hybrid):
/research-feat Add dark mode toggle

# For fixes (local only):
/research-fix Button click not working

# For refactors (hybrid):
/research-refactor Migrate to Zustand state management
```

---

## File Structure

```
exito/
├── agents/
│   ├── task-classifier.md           # NEW
│   ├── local-researcher.md          # NEW (fork from investigator)
│   ├── online-researcher.md         # NEW (based on /research)
│   ├── hybrid-researcher.md         # NEW (orchestrator)
│   └── investigator.md              # ENHANCED
└── commands/
    ├── research.md                  # ENHANCED (add classifier)
    ├── research-feat.md             # NEW
    ├── research-fix.md              # NEW
    ├── research-refactor.md         # NEW
    ├── build.md                     # ENHANCED (add classifier)
    └── workflow.md                  # ENHANCED (add classifier)
```

---

## Session Artifacts

```
.claude/sessions/{command}/{session-id}/
├── classification.md        # Task classifier output
├── context.md              # Local research (or)
├── online_research.md      # Online research (or)
└── unified_context.md      # Hybrid synthesis
```

---

## Token Optimization Tips

1. **File-based context sharing**: Write to files, pass paths
2. **Concise summaries**: Return < 200 words to orchestrator
3. **Parallel execution**: Run local + online simultaneously
4. **Adaptive depth**: Don't over-research trivial tasks
5. **Cache patterns**: Reuse common findings

**Expected savings**: 60-70% vs message passing

---

## Task Type Keywords

| Type | Keywords |
|------|----------|
| **feat** | add feature, new functionality, implement, create new |
| **fix** | fix bug, resolve, correct, repair, patch, debug |
| **refactor** | refactor, restructure, reorganize, improve structure |
| **perf** | optimize, performance, speed up, efficient |
| **docs** | document, add comments, readme, docs |
| **test** | add test, test coverage, unit test |
| **style** | format, style, prettier, lint, cosmetic |
| **chore** | update dependencies, maintenance, housekeeping |
| **build** | build config, webpack, vite, package.json |
| **ci** | ci/cd, github actions, pipeline, deploy |

---

## Common Patterns

### Pattern 1: Fix → Local Only
```
User: "Fix login button not responding"
  → Classifier: fix + small → local + fast-mode
  → Local Researcher: Check button code, event handlers, similar fixes
  → Output: Context with fix approach
```

### Pattern 2: Feature → Hybrid
```
User: "Add real-time notifications"
  → Classifier: feat + medium → hybrid + standard
  → Local: Existing notification patterns, architecture
  → Online: WebSocket best practices, libraries
  → Synthesis: Unified context adapting online to local
```

### Pattern 3: Refactor → Hybrid
```
User: "Refactor to use React Query"
  → Classifier: refactor + large → hybrid + workflow-analysis
  → Local: Current data fetching, API calls
  → Online: React Query docs, migration guides
  → Synthesis: Step-by-step migration plan
```

---

## Best Practices

### DO ✓
- Use task classifier before research
- Write detailed findings to files
- Return concise summaries
- Cite all sources
- Document trade-offs
- Adapt depth to complexity

### DON'T ✗
- Pass large context in messages
- Duplicate research
- Skip classification
- Over-research trivial tasks
- Under-research critical tasks
- Forget to synthesize hybrid findings

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Classification accuracy | >90% |
| Token reduction | 60-70% |
| Research time (small) | <10 min |
| Research time (medium) | <20 min |
| Research time (large) | <30 min |
| User satisfaction | 8+/10 |

---

## Troubleshooting

### Issue: Wrong classification
**Solution**: Review keywords, adjust classifier thresholds, add to training examples

### Issue: Missing online research
**Solution**: Check WebSearch tool availability, verify network access, use local fallback

### Issue: Token usage too high
**Solution**: Check for message-passing anti-pattern, verify file-based sharing, reduce context

### Issue: Research quality low
**Solution**: Increase research depth, add more sources, improve synthesis logic

---

## References

- **Full Report**: `COMPREHENSIVE_REPORT.md`
- **Implementation Roadmap**: `IMPLEMENTATION_ROADMAP.md`
- **Codebase Examples**: `exito/agents/investigator.md`, `exito/commands/research.md`
- **Documentation**: `cc/skills/claude-code-plugin-builder/AGENTS.md`, `WORKFLOWS.md`

---

**Questions?** Review the comprehensive report or consult the plugin documentation.
