# OpenCode Context Templates

Copy these templates into OpenCode sessions to establish context and workflow.

## Usage

```bash
# Before starting a task
cat ~/.config/opencode/context-templates/development-mode.txt

# Then paste into OpenCode session
```

## Templates

### [development-mode.txt](./development-mode.txt)
**Use when:** Writing code, implementing features, fixing bugs

Sets behavior to:
- Write code first, explain after
- Prioritize working solutions
- Run tests after changes
- Keep commits atomic

### [research-mode.txt](./research-mode.txt)
**Use when:** Exploring codebase, understanding architecture, investigating bugs

Sets behavior to:
- Read widely before concluding
- Document findings as you go
- Don't write code until understanding is clear

### [code-review-mode.txt](./code-review-mode.txt)
**Use when:** Reviewing PRs, analyzing code, checking quality

Provides checklist for:
- Logic errors, edge cases, error handling
- Security vulnerabilities
- Performance issues
- Readability

### [model-selection.txt](./model-selection.txt)
**Use when:** Choosing which model to use for a task

Guidelines for:
- Haiku 4.5 - Lightweight, frequent invocation
- Sonnet 4.5 - Main development work
- Opus 4.5 - Complex reasoning
- Context window management

### [tdd-workflow.txt](./tdd-workflow.txt)
**Use when:** Writing new code (MANDATORY for all new features)

Enforces RED-GREEN-REFACTOR cycle:
- Write test first (RED)
- Implement to pass (GREEN)
- Improve code (REFACTOR)
- Verify 80%+ coverage

### [git-workflow.txt](./git-workflow.txt)
**Use when:** Preparing to commit code or create PR

Provides:
- Commit message format (conventional commits)
- Feature implementation workflow
- Code quality checklist
- PR review guidelines

## Best Practices

1. **Always set context before starting** - Copy relevant template at session start
2. **Combine templates** - e.g., [development-mode.txt] + [tdd-workflow.txt]
3. **Follow agent guidelines** - Use @mentions as specified in templates
4. **Manual verification** - OpenCode doesn't enforce rules, so verify manually
5. **Iterate as needed** - Adjust workflows to fit your preferences

## Examples

### Starting a New Feature

```bash
# Copy both development mode and TDD workflow
cat ~/.config/opencode/context-templates/development-mode.txt
cat ~/.config/opencode/context-templates/tdd-workflow.txt

# Paste into OpenCode session, then:
opencode --agent @planner "Plan user authentication feature"
```

### Reviewing a PR

```bash
# Copy code review mode
cat ~/.config/opencode/context-templates/code-review-mode.txt

# Paste into OpenCode session, then:
opencode --agent @code-reviewer "Review authentication implementation"
```

### Researching Codebase

```bash
# Copy research mode
cat ~/.config/opencode/context-templates/research-mode.txt

# Paste into OpenCode session, then:
opencode --agent @architect "Analyze current authentication architecture"
```

## Note

These templates replace Claude Code's automatic `rules/` and `contexts/` enforcement. In OpenCode, you must:
- Manually set context (copy templates)
- Manually invoke agents (@agent-name)
- Manually verify compliance (checklists)

The quality standards remain the same - enforcement is now manual.
