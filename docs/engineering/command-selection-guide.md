# Command Selection Guide

**Last Updated**: November 6, 2025  
**Version**: 1.0

## Purpose

This guide helps you choose the right command for your task. Each command is optimized for specific workflows and complexity levels.

## Quick Decision Tree

```mermaid
graph TD
    A[What are you doing?] --> B{Bug fix?}
    B -->|Yes| C{Simple fix?}
    C -->|Yes < 50 lines| D[/patch]
    C -->|No Complex| E[/build]
    
    B -->|No| F{New feature?}
    F -->|Yes| G{Know exact approach?}
    G -->|Yes| H[/implement]
    G -->|Need exploration| I[/workflow]
    G -->|Starting from scratch| J[/genesis]
    G -->|Highest quality| K[/craft]
    
    F -->|No| L{PR Review?}
    L -->|Yes| M[/review]
    
    L -->|No| N{Frontend work?}
    N -->|Yes| O[/ui]
    N -->|UI perfection| P[/pixel]
    
    N -->|No| Q{Need deep thinking?}
    Q -->|Yes| R[/think]
```

## Command Comparison Matrix

| Command | Research | Planning | User Approval | Implementation | Testing | Review | Duration |
|---------|----------|----------|---------------|----------------|---------|--------|----------|
| `/patch` | Basic | Minimal | ❌ | ✅ | Basic | ❌ | 5-10 min |
| `/implement` | Standard | Fast | ✅ | ✅ | ❌ | ❌ | 15-20 min |
| `/build` | Standard | Standard | ✅ | ✅ | ✅ | ✅ | 25-35 min |
| `/workflow` | Deep | Exploration | ✅ (2x) | Surgical | ✅ | ✅ | 40-60 min |
| `/craft` | Deep | Visionary | ✅ (2x) | Craftsman | ✅ | ✅ | 45-70 min |
| `/genesis` | Deep | First Principles | ✅ (2x) | Greenfield | ✅ | ✅ | 60-90 min |
| `/review` | N/A | N/A | ❌ | N/A | N/A | ✅ | 10-20 min |
| `/ui` | Frontend | Frontend | ✅ | ✅ | Frontend | ✅ | 30-45 min |
| `/pixel` | Visual | Iterative | Multiple | Iterative | Visual | ✅ | 40-60 min |
| `/think` | Deep | Maximum | ✅ | ✅ | ✅ | ✅ | 60-90 min |

## Command Details

### `/patch` - Quick Fix Engineer

**When to use**:
- Simple bug fixes (< 50 lines)
- Typo corrections
- Small style adjustments
- Configuration tweaks
- Dependency updates

**NOT suitable for**:
- New features
- Architecture changes
- Complex refactoring
- Security-critical work

**Characteristics**:
- ⚡ **Speed**: Fastest (5-10 min)
- 🎯 **Precision**: Targeted fixes only
- 🧪 **Testing**: Basic validation
- 📝 **Review**: Skipped (manual recommended)
- 🤖 **Model**: Haiku for speed

**Example**:
```bash
/patch Fix button alignment in Header component
```

---

### `/implement` - Fast Implementation Engineer

**When to use**:
- You know exactly what to build
- Need speed over validation
- Prototyping
- You'll test manually

**Workflow**:
1. Quick research
2. Fast planning
3. Your approval
4. Implementation
5. (No automated testing or review)

**Characteristics**:
- ⚡ **Speed**: Fast (15-20 min)
- 📋 **Planning**: Streamlined
- ⏸️ **Approvals**: 1 checkpoint
- ⚠️ **Testing**: Manual required
- 📝 **Review**: Manual recommended

**Example**:
```bash
/implement Add user profile avatar upload feature
```

---

### `/build` - Universal Senior Engineer

**When to use**:
- Complex features
- Significant changes
- Production code
- Need full validation

**Workflow**:
1. Standard research
2. Detailed planning
3. Your approval
4. Implementation
5. Comprehensive testing
6. Code review

**Characteristics**:
- ⚖️ **Balance**: Quality + Speed
- 📋 **Planning**: Comprehensive
- ⏸️ **Approvals**: 1 checkpoint
- ✅ **Testing**: Full coverage
- 📝 **Review**: Automated

**Example**:
```bash
/build Implement shopping cart with persistent storage
```

---

### `/workflow` - Systematic Workflow Engineer

**When to use**:
- Need to explore multiple solutions
- Complex problems requiring analysis
- Want systematic approach
- Surgical precision required

**Workflow**:
1. Deep discovery
2. Requirements validation
3. Multiple solution exploration
4. **You select best approach**
5. Detailed planning
6. **You approve plan**
7. Surgical implementation (minimal edits)
8. Comprehensive testing
9. Code review
10. Documentation

**Characteristics**:
- 🔍 **Discovery**: Exhaustive
- 💡 **Exploration**: 2-4 alternatives
- ⏸️ **Approvals**: 2 checkpoints
- ✂️ **Implementation**: Surgical (minimal edits, no comments)
- 📝 **Documentation**: Full knowledge base

**Example**:
```bash
/workflow Optimize database query performance for product listings
```

---

### `/craft` - Excellence Craftsman

**When to use**:
- Highest quality bar
- Think Different philosophy
- Ambitious but feasible approaches
- Elegant, maintainable code

**Workflow**:
1. Deep discovery
2. Requirements validation
3. Visionary exploration (first principles)
4. Feasibility validation
5. **You select approach**
6. Detailed architecture
7. **You approve plan**
8. Craftsmanship implementation (TDD, self-documenting, elegant)
9. Testing
10. Review
11. Documentation

**Characteristics**:
- 💡 **Philosophy**: "Think Different"
- 🎨 **Craftsmanship**: Obsessive quality
- ✂️ **Precision**: Surgical edits
- 🧪 **TDD**: Test-driven from start
- 📝 **Documentation**: Comprehensive

**Example**:
```bash
/craft Build real-time collaboration feature with operational transforms
```

---

### `/genesis` - Greenfield Architect

**When to use**:
- Starting from scratch
- No legacy constraints
- First principles thinking
- Clean architecture required

**Workflow**:
1. Vision discovery
2. Requirements validation
3. First principles design
4. Architectural approaches
5. Feasibility validation
6. **You select architecture**
7. ULTRATHINK blueprint
8. **You approve**
9. Greenfield construction (pure, elegant, zero tech debt)
10. Quality validation
11. Documentation

**Characteristics**:
- 🌟 **Greenfield**: Build from zero
- 🏛️ **Clean Architecture**: Pure domain logic
- 🔮 **Future-Proof**: Designed for longevity
- ⏸️ **Approvals**: 2 checkpoints
- 📝 **Documentation**: System knowledge base

**Example**:
```bash
/genesis Create microservice for payment processing with event sourcing
```

---

### `/review` - Comprehensive PR Review

**When to use**:
- Pull Request reviews
- GitHub or Azure DevOps PRs
- Multi-dimensional analysis
- Business requirement validation (optional)

**Workflow**:
1. Context gathering (platform-agnostic)
2. Business validation (if Work Items provided)
3. Parallel analysis (6 specialized agents):
   - Performance
   - Architecture
   - Code Quality
   - Security
   - Testing
   - Accessibility
4. Synthesis into unified report

**Characteristics**:
- 🔍 **Multi-Platform**: GitHub + Azure DevOps
- ⚡ **Parallel**: 6 agents simultaneously
- 📊 **Scoring**: Each dimension rated /10
- 🎯 **Actionable**: File paths, line numbers, fixes
- 📝 **Report**: Comprehensive with action plan

**Example**:
```bash
/review https://github.com/org/repo/pull/123

# With business validation
/review https://github.com/org/repo/pull/123 https://dev.azure.com/org/project/_workitems/edit/456
```

---

### `/ui` - Frontend Senior Engineer

**When to use**:
- React/UI/UX work
- Need accessibility focus
- Responsive design
- Performance optimization
- Frontend best practices

**Workflow**:
1. Frontend-focused research
2. UI/UX planning
3. Your approval
4. Implementation (accessibility + responsive)
5. Frontend testing (cross-browser, a11y, performance)
6. Review

**Characteristics**:
- 🎨 **Focus**: User experience
- ♿ **Accessibility**: WCAG compliance
- 📱 **Responsive**: Mobile-first
- ⚡ **Performance**: Core Web Vitals
- 📝 **Testing**: Lighthouse, screen readers

**Example**:
```bash
/ui Create product comparison table with sortable columns
```

---

### `/pixel` - Pixel Perfectionist

**When to use**:
- Pixel-perfect UI implementation
- Design mockup → code
- Visual refinement needed
- Iterative visual comparison

**Workflow**:
1. Analyze design
2. Implement
3. Screenshot
4. Compare with design
5. Iterate until perfect

**Characteristics**:
- 🎯 **Precision**: Pixel-perfect
- 🔄 **Iterative**: Multiple refinement cycles
- 📸 **Visual**: Screenshot comparison
- ♿ **Accessibility**: WCAG built-in
- 🎨 **Design**: High fidelity

**Example**:
```bash
/pixel Implement dashboard from Figma design
```

---

### `/think` - Deep Thinking Engineer

**When to use**:
- Maximum analysis needed
- Critical architectural decisions
- Complex problem exploration
- Need exhaustive planning

**Workflow**:
1. Deep research (30-40 min)
2. Maximum planning (ULTRATHINK)
3. Your approval
4. Maximum-care implementation
5. Comprehensive testing
6. Exhaustive review
7. Full documentation

**Characteristics**:
- 🧠 **Thinking**: ULTRATHINK mode
- 📊 **Analysis**: Exhaustive
- 📋 **Planning**: 5+ alternatives
- ⏳ **Duration**: Longest (60-90 min)
- 📝 **Documentation**: Complete

**Example**:
```bash
/think Redesign authentication system with OAuth2 and SSO
```

---

## Use Case Examples

### Scenario: Bug in Production

**Problem**: Button is misaligned on checkout page

**Choice**: `/patch`  
**Why**: Simple fix, urgent, < 50 lines

---

### Scenario: New User Story

**Problem**: As a user, I want to filter products by price range

**Choice**: `/build` (if straightforward) or `/workflow` (if exploration needed)  
**Why**: Feature development with testing needs

---

### Scenario: Major Architecture Change

**Problem**: Migrate from REST to GraphQL

**Choice**: `/think` (existing codebase) or `/genesis` (starting fresh)  
**Why**: Critical decision, needs deep analysis

---

### Scenario: UI Redesign

**Problem**: Implement new design system components

**Choice**: `/ui` (general) or `/pixel` (high-fidelity mockups)  
**Why**: Frontend focus, accessibility, responsive

---

### Scenario: Code Review Needed

**Problem**: Review PR before merge

**Choice**: `/review`  
**Why**: Multi-dimensional analysis, actionable feedback

---

## Choosing Between Similar Commands

### `/build` vs `/implement` vs `/craft`

| Consideration | `/implement` | `/build` | `/craft` |
|---------------|--------------|----------|----------|
| **Speed** | Fast (15-20 min) | Moderate (25-35 min) | Slower (45-70 min) |
| **Testing** | Manual | Automated | TDD from start |
| **Review** | Manual | Automated | Automated + Philosophy |
| **Quality Bar** | Good enough | Production ready | Excellence |
| **Use when** | Prototyping | Standard work | Critical/showcase code |

### `/workflow` vs `/execute`

**Note**: `/execute` appears redundant. Use `/workflow` for systematic development.

### `/craft` vs `/genesis` vs `/workflow`

| Consideration | `/workflow` | `/craft` | `/genesis` |
|---------------|-------------|----------|------------|
| **Context** | Existing codebase | Existing/new | Greenfield only |
| **Philosophy** | Systematic | "Think Different" | First principles |
| **Approach** | Multiple explored | Visionary | Architectural |
| **Implementation** | Surgical (minimal) | Craftsman (TDD) | Pure (no debt) |
| **Use when** | Need exploration | Need excellence | Starting fresh |

---

## Decision Factors

### Project Constraints

| Factor | Fast Option | Balanced Option | Quality Option |
|--------|-------------|-----------------|----------------|
| **Time** | `/patch`, `/implement` | `/build`, `/ui` | `/craft`, `/think` |
| **Quality** | Good enough | Production ready | Excellence |
| **Risk** | Low | Medium | High (critical) |

### Team Context

| Consideration | Option |
|---------------|--------|
| **Junior developer will maintain** | `/build` (clear, well-tested) |
| **Showcase/critical code** | `/craft` (excellence) |
| **Legacy codebase** | `/workflow` (surgical) |
| **Greenfield project** | `/genesis` (pure architecture) |

### Problem Complexity

| Complexity | Command |
|------------|---------|
| **Trivial** (< 50 lines) | `/patch` |
| **Small** (< 200 lines) | `/implement` or `/build` |
| **Medium** (200-500 lines) | `/build` or `/workflow` |
| **Large** (500-1000 lines) | `/workflow` or `/craft` |
| **Very Large** (> 1000 lines) | `/think` or `/genesis` |

---

## Anti-Patterns

### ❌ DON'T

- Use `/patch` for new features (use `/implement` or `/build`)
- Use `/genesis` on existing codebases (use `/workflow` or `/craft`)
- Skip `/review` before merging (always review)
- Use `/think` for simple tasks (overkill, use `/build`)
- Use `/implement` for production code without manual testing

### ✅ DO

- Match command to task complexity
- Use fast commands for iteration, thorough commands for production
- Combine commands (e.g., `/workflow` for design → `/pixel` for UI)
- Trust the systematic workflows (`/workflow`, `/craft`, `/genesis`)
- Use `/review` consistently

---

## Command Chaining Examples

### Multi-Stage Development

```bash
# Stage 1: Explore design
/workflow Design user authentication flow

# (After approval and implementation)

# Stage 2: Perfect the UI
/pixel Implement login page from Figma mockup

# Stage 3: Review before merge
/review https://github.com/org/repo/pull/789
```

### Research → Implementation

```bash
# Stage 1: Deep research
/research Best practices for real-time collaboration

# (Review research findings)

# Stage 2: Implement with knowledge
/craft Build collaborative editing feature
```

---

## When in Doubt

**Default choices by task type**:

- **Bug fix**: Start with `/patch`, escalate to `/build` if complex
- **New feature**: Start with `/build`, use `/workflow` if uncertain
- **UI work**: Use `/ui`, escalate to `/pixel` for high fidelity
- **Architecture**: Use `/think` for existing, `/genesis` for new
- **Review**: Always use `/review`

---

## Feedback & Iteration

This guide evolves based on usage patterns. If you find yourself:

- Frequently switching commands mid-task → Command selection may need refinement
- Consistently needing manual fixes after automation → Consider higher-quality command
- Waiting too long → Consider faster command

Share feedback to improve this guide!

---

## Related Documentation

- [Agent Catalog](../../exito/AGENTS.md) - All available agents
- [Quick Reference](../../exito/QUICKREF.md) - Command syntax reference
- [Agent Structure Standard](./agent-structure-standard.md) - How agents work
- [Architecture Decision Records](./adr/) - Why things work this way

---

**Remember**: The best command is the one that matches your needs. When in doubt, start conservative (`/build`) and escalate as needed.

