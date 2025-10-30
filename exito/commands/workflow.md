## Phase 1: Discovery & Analysis

**Objective**: Gather comprehensive context about the problem without making changes.

**Actions**:

- Explore all files and components related to `$PROBLEM`
- Check for relevant documentation, tests, and configuration files
- Understand the current implementation and dependencies
- Identify any related issues, PRs, or technical decisions

**Output**: Complete understanding of the problem domain

---

## Phase 2: Requirements Validation

**Objective**: Confirm you have sufficient information to proceed with implementation.

**Checklist**:

- ✓ Problem scope is clearly defined
- ✓ All relevant context has been gathered
- ✓ Edge cases and dependencies are identified
- ✓ Architecture and design patterns are understood

**Decision Gate**:

- If information is insufficient, request clarification with specificity
- If information is adequate, proceed to Phase 3

**Output**: Validated requirements document or confirmation

---

## Phase 3: Solution Design

**Objective**: Create a clear, actionable plan before writing code.

**Deliverables**:

- High-level solution architecture
- Step-by-step implementation plan
- List of files to create/modify
- Potential risks and mitigation strategies
- Testing approach

**Format**: Use structured breakdown with logical sequencing

- Break complex tasks into smaller, manageable steps
- Identify dependencies and execution order
- Define success criteria for each step

**Tool**: Create a todo list for tracking

**Output**: Comprehensive implementation plan

---

## Phase 4: Implementation & Verification

**Objective**: Execute the plan while maintaining code quality and correctness.

**Process**:

1. Mark one todo as `in-progress` before starting work
2. Implement each step according to the plan
3. Verify each implementation:
   - Validate against requirements
4. Mark todo as `completed` immediately after verification
5. Proceed to the next step
6. Update the todo list as new dependencies are discovered

**Key Principles**:

- Keep one task in focus at a time

**Output**: Complete implementation

---

## Phase 5: Documentation & Closure

**Objective**: Record the solution and implementation details for future reference.

**Deliverables**:

1. Create markdown document in `./documentacion/` with naming convention: `{YYYYMMDD}-{brief-solution-name}.md`
2. Include:
   - Executive summary

**Output**: Complete documentation for project knowledge base

---

## Best Practices

- **Be thorough in discovery** - invest time upfront to avoid rework
- **Ask for clarity** - don't proceed with ambiguous requirements
- **Break complexity** - divide large tasks into smaller, verifiable steps
- **Verify continuously** - check each step before moving forward
- **Document everything** - enable future developers to understand decisions
