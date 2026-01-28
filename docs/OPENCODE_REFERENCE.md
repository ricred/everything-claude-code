# OpenCode Compatibility Reference Guide

**Version:** 2.0.0 (OpenCode Edition)
**Last Updated:** 2025-01-28

## Table of Contents

- [Configuration Schemas](#configuration-schemas)
- [Agent Format](#agent-format)
- [Skill Format](#skill-format)
- [Permission System](#permission-system)
- [Migration Patterns](#migration-patterns)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Configuration Schemas

### Agent Configuration (Markdown Format)

```yaml
---
mode: subagent
description: [Brief description of agent's purpose]
model: anthropic/claude-[model-name]
temperature: [0.0-1.0]
tools:
  read: [true/false]
  grep: [true/false]
  glob: [true/false]
  view: [true/false]
  write: [true/false]
  edit: [true/false]
  bash: [true/false]
---
```

**Fields:**
- `mode`: `subagent` for specialist agents, `primary` for Build/Plan equivalents
- `description`: One-line summary of agent purpose
- `model`: Model to use (anthropic/claude-sonnet-4-20250514, haiku-4-5-20250414, opus-4-5-20250414)
- `temperature`: Creativity level (0.0 = deterministic, 1.0 = very creative)
- `tools`: Tool access (read-only agents set write/edit/bash to false)

### Skill Configuration (SKILL.md Format)

```yaml
---
name: [skill-name]
description: [Brief description of skill's purpose]
mode: subagent
model: anthropic/claude-[model-name]
temperature: [0.0-1.0]
tools:
  read: [true/false]
  grep: [true/false]
  glob: [true/false]
  view: [true/false]
  write: [true/false]
  edit: [true/false]
  bash: [true/false]
---
```

**Fields:** Same as agent configuration, plus:
- `name`: Skill identifier for discovery

### Global Configuration (opencode.json)

```json
{
  "agents_path": ["~/.config/opencode/agents"],
  "skills_paths": ["~/.config/opencode/skills", ".opencode/skills"],
  "default_agent": {
    "model": "anthropic/claude-sonnet-4-20250514",
    "temperature": 0.2
  },
  "permissions": {
    "default": "allow",
    "agent_overrides": {
      "planner": "ask",
      "architect": "ask",
      "tdd-guide": "allow"
    }
  }
}
```

### Project Initialization (AGENTS.md)

```markdown
# Project: [Project Name]

## Available Agents
- @planner - Implementation planning
- @architect - System design
- @tdd-guide - Test-driven development
- @code-reviewer - Code quality review
- @security-reviewer - Security analysis

## Available Skills
- coding-standards - Universal coding patterns
- backend-patterns - Backend architecture
- frontend-patterns - Frontend patterns
- tdd-workflow - TDD methodology

## Project Standards
- TDD: 80%+ coverage required
- Style: Immutability, small files
- Security: No hardcoded secrets
- Git: Conventional commits

## Context Templates
Copy from ~/.config/opencode/context-templates/:
- development-mode.txt
- research-mode.txt
- code-review-mode.txt
```

---

## Agent Format

### Example: Planner Agent

```markdown
---
description: Expert planning specialist for complex features and refactoring. Creates comprehensive, actionable implementation plans.
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  read: true
  grep: true
  glob: true
  view: true
  write: false
  edit: false
  bash: false
---

You are an expert planning specialist focused on creating comprehensive, actionable implementation plans.

## Your Role
- Analyze requirements and create detailed implementation plans
- Break down complex features into manageable steps
- Identify dependencies and risks
- Prioritize tasks logically

## When to Use
- Feature implementation planning
- Architectural changes
- Complex refactoring
- System redesign

## Planning Methodology
1. Understand requirements
2. Analyze current state
3. Break down into phases
4. Identify dependencies
5. Assess risks
6. Create actionable plan
```

### Example: Implementation Agent (Write-Enabled)

```markdown
---
description: Test-Driven Development specialist enforcing write-tests-first methodology.
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  read: true
  grep: true
  glob: true
  view: true
  write: true
  edit: true
  bash: true
---

You are a Test-Driven Development (TDD) specialist.

## Your Role
- Enforce tests-before-code methodology
- Guide through Red-Green-Refactor cycle
- Maintain high test coverage (80%+)

## When to Use
- Writing new features
- Fixing bugs
- Refactoring code
- Adding tests
```

---

## Skill Format

### Example: Coding Standards Skill

```markdown
---
name: coding-standards
description: Universal coding standards, best practices, and patterns for TypeScript, JavaScript, React, and Node.js.
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.2
tools:
  read: true
  grep: true
  glob: true
  view: true
  write: false
  edit: false
  bash: false
---

You are a comprehensive coding standards reference.

## When to Use
- Writing TypeScript/JavaScript
- Designing React components
- Creating Node.js APIs
- Reviewing code quality

## Core Principles
- Immutability first
- Small, focused functions
- Clear error handling
- Comprehensive testing
```

---

## Permission System

### Permission Levels

OpenCode uses three permission levels:

1. **allow** - Tool can be used automatically
2. **ask** - Require user confirmation before use
3. **deny** - Tool cannot be used

### Permission Hierarchy

```
Global Default
    ↓
Agent-Specific Override
    ↓
Runtime Request
```

### Example Configuration

```json
{
  "permissions": {
    "default": "ask",  // Default to ask
    "agent_overrides": {
      "planner": {
        "read": "allow",
        "grep": "allow",
        "glob": "allow",
        "view": "allow",
        "write": "deny",   // Planner shouldn't write
        "edit": "deny",    // Planner shouldn't edit
        "bash": "deny"     // Planner shouldn't run commands
      },
      "tdd-guide": {
        "read": "allow",
        "grep": "allow",
        "glob": "allow",
        "view": "allow",
        "write": "allow",   // TDD guide needs to write tests
        "edit": "allow",    // TDD guide needs to edit code
        "bash": "allow"     // TDD guide needs to run tests
      }
    }
  }
}
```

### Recommended Permissions

| Agent | Read | Grep | Glob | View | Write | Edit | Bash | Rationale |
|--------|-------|-------|-------|-------|-------|-------|-----------|
| planner | allow | allow | allow | allow | deny | deny | deny | Read-only planning |
| architect | allow | allow | allow | allow | deny | deny | deny | Read-only design |
| tdd-guide | allow | allow | allow | allow | allow | allow | allow | Implementation needed |
| code-reviewer | allow | allow | allow | allow | deny | deny | deny | Read-only review |
| security-reviewer | allow | allow | allow | allow | deny | deny | deny | Read-only analysis |

---

## Migration Patterns

### Pattern 1: Read-Only Analysis

**Use Case:** Code review, architecture assessment, security analysis

**Agent Permissions:**
```yaml
tools:
  read: true
  grep: true
  glob: true
  view: true
  write: false
  edit: false
  bash: false
```

**Examples:**
- @code-reviewer - Review code quality
- @architect - Assess architecture
- @security-reviewer - Security analysis

### Pattern 2: Implementation Agent

**Use Case:** Writing code, running tests, building

**Agent Permissions:**
```yaml
tools:
  read: true
  grep: true
  glob: true
  view: true
  write: true
  edit: true
  bash: true
```

**Examples:**
- @tdd-guide - TDD implementation
- @build-agent - Build and test

### Pattern 3: Context-Setting Workflow

**Use Case:** Establishing session behavior

**Steps:**
1. Copy context template to clipboard
2. Paste into OpenCode session
3. Work according to template guidelines

**Templates Location:** `~/.config/opencode/context-templates/`

### Pattern 4: Manual Compaction

**Use Case:** Clearing context to free tokens

**Steps:**
1. Run: `.opencode/scripts/reset-context.sh`
2. Select compaction type
3. Paste template into session
4. Continue with fresh context

### Pattern 5: Multi-Agent Coordination

**Use Case:** Complex problems requiring multiple perspectives

**Steps:**
1. Plan with @planner
2. Run parallel sessions:
   - Session 1: @security-reviewer
   - Session 2: @architect
   - Session 3: @code-reviewer
3. Synthesize results manually
4. Create unified plan

---

## Best Practices

### 1. Agent Selection

**Rule:** Choose agent based on task, not convenience

**Guidelines:**
- Complex planning → @planner
- Architecture decisions → @architect
- New code → @tdd-guide
- After writing → @code-reviewer
- Security concerns → @security-reviewer

### 2. Permission Management

**Rule:** Restrict agent tools to match purpose

**Guidelines:**
- Analysis agents → read-only (no write/edit/bash)
- Implementation agents → full access
- Security-critical → ask permission
- Production deployments → ask permission

### 3. Context Management

**Rule:** Use context templates at session start

**Guidelines:**
- Development work → development-mode.txt
- Research tasks → research-mode.txt
- Code review → code-review-mode.txt
- Compaction → compact-*.txt templates

### 4. Skill Discovery

**Rule:** Let OpenCode discover skills automatically

**Guidelines:**
- Place skills in `~/.config/opencode/skills/`
- Use proper SKILL.md format
- Include descriptive name and description
- Test skill activation

### 5. Continuous Learning

**Rule:** Manual daily reflection for pattern extraction

**Guidelines:**
- End of day: Run `daily-reflection.sh`
- Identify effective patterns
- Extract as skills to `~/.config/opencode/skills/learned/`
- Update confidence scores over time

---

## Troubleshooting

### Agent Not Discovered

**Symptom:** `@agent-name` doesn't work

**Solutions:**
1. Verify agent file exists: `ls ~/.config/opencode/agents/`
2. Check file format: Must have YAML frontmatter
3. Verify agent name: File name without `.md` extension
4. Restart OpenCode to reload agents

### Skill Not Discovered

**Symptom:** Skill not activated when mentioned

**Solutions:**
1. Verify skills_path configuration: Check `opencode.json`
2. Check file format: Must be `SKILL.md` (not `skill.md`)
3. Verify frontmatter: Must include `name` field
4. Restart OpenCode to reload skills

### Permission Errors

**Symptom:** Agent/skill unable to use required tool

**Solutions:**
1. Check permissions in agent/skill frontmatter
2. Verify global default in `opencode.json`
3. Check for agent-specific overrides
4. Adjust to `allow` if agent needs tool

### Context Not Loading

**Symptom:** Context templates don't set behavior

**Solutions:**
1. Manually copy template content to clipboard
2. Paste into OpenCode session
3. Follow template guidelines explicitly
4. Use AGENTS.md for project initialization

### Script Execution Failures

**Symptom:** Helper scripts fail to run

**Solutions:**
1. Verify script is executable: `chmod +x script.sh`
2. Check script path: Must be in `.opencode/scripts/`
3. Verify bash shebang: Must be `#!/bin/bash`
4. Test script independently: `./script.sh`

---

## Quick Reference

### Agent Invocation

```bash
# In OpenCode session
@planner [task description]
@architect [system design question]
@tdd-guide [implementation task]
@code-reviewer [review request]
@security-reviewer [security analysis]
```

### Context Templates

```bash
# Copy to clipboard
cat ~/.config/opencode/context-templates/development-mode.txt | pbcopy  # macOS
cat ~/.config/opencode/context-templates/development-mode.txt | xclip  # Linux
cat ~/.config/opencode/context-templates/development-mode.txt | clip   # Windows
```

### Helper Scripts

```bash
# Daily reflection
.opencode/scripts/daily-reflection.sh

# Session summary
.opencode/scripts/save-session.sh

# Context reset
.opencode/scripts/reset-context.sh

# Load memory
.opencode/scripts/load-memory.sh
```

### Configuration Files

| File | Location | Purpose |
|-------|-----------|---------|
| Agent definitions | `~/.config/opencode/agents/*.md` | Specialist agents |
| Skill definitions | `~/.config/opencode/skills/*/SKILL.md` | Skills library |
| Context templates | `~/.config/opencode/context-templates/*.txt` | Session contexts |
| Helper scripts | `.opencode/scripts/*.sh` | Workflow helpers |
| Project initialization | `.opencode/AGENTS.md` | Project-specific config |
| Global config | `~/.config/opencode/opencode.json` | Global settings |

---

## Advanced Topics

### Temperature Settings

| Value | Use Case | Effect |
|--------|-----------|--------|
| 0.0 | Code generation, precise implementation | Very deterministic |
| 0.2 | Planning, architecture, code review | Low creativity, high precision |
| 0.5 | General assistance, balanced tasks | Balanced creativity and precision |
| 0.7 | Exploratory tasks, brainstorming | Higher creativity |
| 1.0 | Creative writing, idea generation | Maximum creativity |

### Model Selection

| Model | Use Case | Strengths | Limitations |
|--------|-----------|------------|-------------|
| Haiku 4.5 | Lightweight tasks, frequent invocations | Fast, cheap | Less reasoning depth |
| Sonnet 4.5 | Main development, code generation | Best balance of cost/capability | Slower than Haiku |
| Opus 4.5 | Complex reasoning, architecture | Deepest reasoning | Most expensive |

### Cross-Platform Compatibility

All scripts and tools tested on:
- ✅ Linux (Ubuntu 22.04)
- ✅ macOS (Sonoma 14.x)
- ⏸️ Windows 11 (needs testing)

---

## Resources

### Documentation

- [OpenCode Documentation](https://opencode.ai/docs/)
- [Migration Guide](./MIGRATION_PLAN.md)
- [Architecture Research](./opencode-architecture.md)
- [Testing Report](./opencode-testing-report.md)

### Configuration

- [Agents Directory](~/.config/opencode/agents/)
- [Skills Directory](~/.config/opencode/skills/)
- [Context Templates](~/.config/opencode/context-templates/)
- [Helper Scripts](.opencode/scripts/)

### Community

- [OpenCode GitHub](https://github.com/anomalyco/opencode)
- [OpenCode Discord](https://discord.gg/opencode)

---

**Version:** 2.0.0
**Last Updated:** 2025-01-28
**Status:** Production Ready ✅
