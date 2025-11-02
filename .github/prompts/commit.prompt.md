---
description: Create well-formatted commits with conventional commit format and emoji
mode: agent
---

# Smart Git Commit

Create well-formatted commit: $ARGUMENTS

## Usage

**Command Arguments:**

- `[message]` - Commit message (optional, will be auto-generated if not provided)
- `--no-verify` - Skip running pre-commit checks (lint, build, generate:docs)
- `--amend` - Amend the previous commit instead of creating a new one

**Allowed Tools:**

- `bash` (git add, git status, git commit, git diff, git log)

## Current Repository State

- Git status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Staged changes: !`git diff --cached --stat`
- Unstaged changes: !`git diff --stat`
- Recent commits: !`git log --oneline -5`

## Intelligent Commit Workflow

### Phase 1: Analyze Current State

1. Check if files are already staged: `git diff --cached --stat`
2. If staged files exist: Commit only those (respect manual staging)
3. If no staged files: Proceed to intelligent grouping

### Phase 2: Understand All Changes

```bash
# Get detailed status with change types
git status --porcelain

# Output format:
# A  = Added (new file, staged)
# M  = Modified
# D  = Deleted
# ?? = Untracked
# R  = Renamed
```

### Phase 3: Identify Logical Groups

Analyze the changes and identify distinct groups:

- New plugins/features (by directory)
- Refactoring/moves (renamed/moved files)
- Deletions (obsolete code removal)
- Fixes (bug fixes, typo corrections)
- Documentation (README, guides)

### Phase 4: Create Atomic Commits

For each group (in order of priority):

1. Stage the group: `git add path/to/group/`
2. Review staged changes: `git diff --cached --stat`
3. Create descriptive commit with appropriate emoji
4. Move to next group

### Phase 5: Verify

- Check all changes are committed: `git status`
- Review commit history: `git log --oneline -5`

## Best Practices for Commits

- **Verify before committing**: Ensure code is linted, builds correctly, and documentation is updated
- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Split large changes**: If changes touch multiple concerns, split them into separate commits
- **Conventional commit format**: Use the format `<type>: <description>` where type is one of:
  - `feat`: A new feature
  - `fix`: A bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `perf`: Performance improvements
  - `test`: Adding or fixing tests
  - `chore`: Changes to the build process, tools, etc.
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters
- **Emoji**: Each commit type is paired with an appropriate emoji:
  - ✨ `feat`: New feature
  - 🐛 `fix`: Bug fix
  - 📝 `docs`: Documentation
  - 💄 `style`: Formatting/style
  - ♻️ `refactor`: Code refactoring
  - ⚡️ `perf`: Performance improvements
  - ✅ `test`: Tests
  - 🔧 `chore`: Tooling, configuration
  - 🚀 `ci`: CI/CD improvements
  - 🗑️ `revert`: Reverting changes
  - 🧪 `test`: Add a failing test
  - 🚨 `fix`: Fix compiler/linter warnings
  - 🔒️ `fix`: Fix security issues
  - 👥 `chore`: Add or update contributors
  - 🚚 `refactor`: Move or rename resources
  - 🏗️ `refactor`: Make architectural changes
  - 🔀 `chore`: Merge branches
  - 📦️ `chore`: Add or update compiled files or packages
  - ➕ `chore`: Add a dependency
  - ➖ `chore`: Remove a dependency
  - 🌱 `chore`: Add or update seed files
  - 🧑‍💻 `chore`: Improve developer experience
  - 🧵 `feat`: Add or update code related to multithreading or concurrency
  - 🔍️ `feat`: Improve SEO
  - 🏷️ `feat`: Add or update types
  - 💬 `feat`: Add or update text and literals
  - 🌐 `feat`: Internationalization and localization
  - 👔 `feat`: Add or update business logic
  - 📱 `feat`: Work on responsive design
  - 🚸 `feat`: Improve user experience / usability
  - 🩹 `fix`: Simple fix for a non-critical issue
  - 🥅 `fix`: Catch errors
  - 👽️ `fix`: Update code due to external API changes
  - 🔥 `fix`: Remove code or files
  - 🎨 `style`: Improve structure/format of the code
  - 🚑️ `fix`: Critical hotfix
  - 🎉 `chore`: Begin a project
  - 🔖 `chore`: Release/Version tags
  - 🚧 `wip`: Work in progress
  - 💚 `fix`: Fix CI build
  - 📌 `chore`: Pin dependencies to specific versions
  - 👷 `ci`: Add or update CI build system
  - 📈 `feat`: Add or update analytics or tracking code
  - ✏️ `fix`: Fix typos
  - ⏪️ `revert`: Revert changes
  - 📄 `chore`: Add or update license
  - 💥 `feat`: Introduce breaking changes
  - 🍱 `assets`: Add or update assets
  - ♿️ `feat`: Improve accessibility
  - 💡 `docs`: Add or update comments in source code
  - 🗃️ `db`: Perform database related changes
  - 🔊 `feat`: Add or update logs
  - 🔇 `fix`: Remove logs
  - 🤡 `test`: Mock things
  - 🥚 `feat`: Add or update an easter egg
  - 🙈 `chore`: Add or update .gitignore file
  - 📸 `test`: Add or update snapshots
  - ⚗️ `experiment`: Perform experiments
  - 🚩 `feat`: Add, update, or remove feature flags
  - 💫 `ui`: Add or update animations and transitions
  - ⚰️ `refactor`: Remove dead code
  - 🦺 `feat`: Add or update code related to validation
  - ✈️ `feat`: Improve offline support

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down

## Intelligent Grouping Strategy

When no files are staged, analyze all changes and group them intelligently:

### Step 1: Analyze Changes

Run `git status --porcelain` to see all changes:

- `A` = New files (added)
- `M` = Modified files
- `D` = Deleted files
- `R` = Renamed files
- `??` = Untracked files

### Step 2: Identify Logical Groups

Group changes by **purpose and context**, not just by file type:

**Example grouping patterns:**

1. **New Features/Plugins** (separate commit per feature):

   - All new files in a plugin directory (`plugin-name/`)
   - Include related config files (`plugin.json`, etc.)
   - Commit type: `🎉 feat:` or `✨ feat:`

2. **Refactoring/Reorganization** (separate commits):
   - Moving/renaming directories
   - Commit type: `🚚 refactor:` or `🏗️ refactor:`
3. **Deletions/Cleanup** (separate commit):

   - Removing obsolete code, old plugins
   - Commit type: `🗑️ refactor:` or `🔥 fix:`

4. **Metadata/Config Updates** (separate commit):

   - Version bumps, URL fixes, metadata corrections
   - Commit type: `✏️ fix:` or `🔧 chore:`

5. **Documentation** (separate commit):
   - README updates, doc changes
   - Commit type: `📝 docs:`

### Step 3: Create Commits in Logical Order

**Recommended order:**

1. New features/additions first (they add value)
2. Refactoring/reorganization (they improve structure)
3. Deletions/cleanup (they remove obsolete code)
4. Fixes/corrections (they fix issues)
5. Documentation updates (they explain changes)

### Step 4: Smart Staging Commands

Use precise git commands to stage by group:

```bash
# Stage specific directory
git add path/to/directory/

# Stage specific files
git add file1.json file2.md

# Stage all deletions
git add -u

# Stage by pattern
git add '*.json'
```

### Example: Real-World Grouping

Given these changes:

```
A  cc/.claude-plugin/plugin.json
A  cc/claude-code-plugin-builder/README.md
A  cc/claude-code-plugin-builder/...  (15 files)
M  exito/.claude-plugin/plugin.json
D  tools/.claude-plugin/plugin.json
D  tools/commands/setup-azure.md
D  tools/commands/...  (3 files)
?? setup/.claude-plugin/plugin.json
?? setup/commands/...  (3 files)
```

**Intelligent grouping:**

**Commit 1** - New feature (cc/ plugin):

```bash
git add cc/
git commit -m "🎉 feat: add claude-code-plugin-builder to marketplace

- Complete plugin builder with comprehensive documentation
- Agent system, commands, hooks, MCP, workflow guides
- Ready-to-use templates
- Located in cc/ (Claude Code plugins marketplace)"
```

**Commit 2** - New feature (setup/ plugin):

```bash
git add setup/
git commit -m "🔧 feat: add setup plugin for development environment

- Azure CLI, GitHub CLI, uv setup commands
- Multi-platform support (macOS, Linux, Windows)
- Authentication guides and troubleshooting"
```

**Commit 3** - Cleanup (remove obsolete):

```bash
git add tools/
git commit -m "🗑️ refactor: remove obsolete tools plugin

- Replaced by new setup plugin with better organization
- Setup commands moved to dedicated plugin"
```

**Commit 4** - Fix (metadata correction):

```bash
git add exito/.claude-plugin/plugin.json
git commit -m "✏️ fix: correct repository URLs in exito plugin

- Update GitHub username to yersonargotev
- Fix homepage and repository URLs"
```

### Anti-Patterns to Avoid

❌ **Don't do this:**

- `git add -A` followed by one massive commit
- Mixing new features with deletions in same commit
- Combining unrelated changes (e.g., plugin A + plugin B)
- Generic messages like "Update files" or "Various changes"

✅ **Do this instead:**

- Analyze changes first (`git status --porcelain`)
- Group by logical concern
- Stage one group at a time
- Write specific, descriptive commit messages
- One commit per logical unit of work

## Examples

Good commit messages:

- ✨ feat: add user authentication system
- 🐛 fix: resolve memory leak in rendering process
- 📝 docs: update API documentation with new endpoints
- ♻️ refactor: simplify error handling logic in parser
- 🚨 fix: resolve linter warnings in component files
- 🧑‍💻 chore: improve developer tooling setup process
- 👔 feat: implement business logic for transaction validation
- 🩹 fix: address minor styling inconsistency in header
- 🚑️ fix: patch critical security vulnerability in auth flow
- 🎨 style: reorganize component structure for better readability
- 🔥 fix: remove deprecated legacy code
- 🦺 feat: add input validation for user registration form
- 💚 fix: resolve failing CI pipeline tests
- 📈 feat: implement analytics tracking for user engagement
- 🔒️ fix: strengthen authentication password requirements
- ♿️ feat: improve form accessibility for screen readers

Real-world example of intelligent grouping (Claude Code Marketplace):

**Scenario:** Multiple changes across different plugins

```
Status:
A  cc/claude-code-plugin-builder/...  (16 files)
M  exito/.claude-plugin/plugin.json
D  tools/...  (4 files)
?? setup/...  (4 files)
```

**Intelligent commits created:**

1. ✨ `🎉 feat: add claude-code-plugin-builder to marketplace`
   - Groups: All new files in cc/ directory
   - 6,320 lines of new plugin code
2. ✨ `🔧 feat: add setup plugin for development environment`
   - Groups: All new files in setup/ directory
   - 925 lines of setup commands
3. ♻️ `🗑️ refactor: remove obsolete tools plugin`
   - Groups: All deleted files in tools/ directory
   - Replaced by better organized plugin
4. 🐛 `✏️ fix: correct repository URLs in exito plugin`
   - Groups: Single metadata file modification
   - URL typo correction

Example of splitting unrelated changes:

- First commit: ✨ feat: add new solc version type definitions
- Second commit: 📝 docs: update documentation for new solc versions
- Third commit: 🔧 chore: update package.json dependencies
- Fourth commit: 🏷️ feat: add type definitions for new API endpoints
- Fifth commit: 🧵 feat: improve concurrency handling in worker threads
- Sixth commit: 🚨 fix: resolve linting issues in new code
- Seventh commit: ✅ test: add unit tests for new solc version features
- Eighth commit: 🔒️ fix: update dependencies with security vulnerabilities

## Command Options

- `--no-verify`: Skip running the pre-commit checks (lint, build, generate:docs)

## Important Notes

- By default, pre-commit checks (`pnpm lint`, `pnpm build`, `pnpm generate:docs`) will run to ensure code quality
- If these checks fail, you'll be asked if you want to proceed with the commit anyway or fix the issues first
- **If no files are staged**: Analyze ALL changes with `git status --porcelain`, then intelligently group them
- **If files are already staged**: Only commit those files (respect user's manual staging)
- **Always analyze before committing**: Use `git status --porcelain` and `git diff` to understand changes
- **Create multiple atomic commits**: One per logical group of changes
- **Follow commit order**: New features → Refactoring → Deletions → Fixes → Documentation
- **Reset if needed**: Use `git reset` to unstage and reorganize if initial staging wasn't optimal
- Each commit message must accurately describe its specific group of changes
