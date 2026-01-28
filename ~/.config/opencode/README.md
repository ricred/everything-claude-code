# Global OpenCode Configuration

**Location:** `~/.config/opencode/`
**Version:** 2.0.0
**Purpose:** Global agents, skills, templates, and configuration available to ALL projects

---

## Quick Start

### 1. Use in ANY Project

```bash
# Navigate to any project on your machine
cd /path/to/your-project

# Start OpenCode
opencode
```

### 2. Your Agents Work Automatically

```
@planner Create implementation plan for X
@architect Review architecture for Y
@tdd-guide Implement feature Z with TDD
@code-reviewer Review my changes
@security-reviewer Check for security issues
```

### 3. Your Skills Are Auto-Discovered

All skills in `~/.config/opencode/skills/` are automatically available:

- coding-standards
- backend-patterns
- frontend-patterns
- tdd-workflow
- And 11 more...

---

## What's Available Globally

### Agents (5)
```
~/.config/opencode/agents/
├── planner.md
├── architect.md
├── tdd-guide.md
├── code-reviewer.md
└── security-reviewer.md
```

### Skills (15)
```
~/.config/opencode/skills/
├── coding-standards/
├── backend-patterns/
├── frontend-patterns/
├── tdd-workflow/
└── ... 11 more skills
```

### Context Templates (9)
```
~/.config/opencode/context-templates/
├── development-mode.txt
├── research-mode.txt
├── code-review-mode.txt
└── ... 6 more templates
```

---

## Usage Examples

### Example 1: New Project
```bash
cd ~/projects/new-website
opencode

# Type:
@planner Create plan for user authentication system
```

### Example 2: Existing Project
```bash
cd ~/existing/codebase
opencode

# Type:
@tdd-guide Fix login bug following TDD methodology
```

### Example 3: Anywhere
```bash
cd /any/directory
opencode

# All your agents and skills just work!
```

---

## Copying Context Templates

To use context templates in any project:

```bash
# Copy to clipboard
cat ~/.config/opencode/context-templates/development-mode.txt | pbcopy  # macOS
cat ~/.config/opencode/context-templates/development-mode.txt | xclip  # Linux
cat ~/.config/opencode/context-templates/development-mode.txt | clip   # Windows

# Then paste into OpenCode session
```

---

## Adding Project-Specific Assets

If you want project-specific agents/skills (override or add to global):

```bash
# In your project directory
cd /path/to/your-project

# Create project-specific directory
mkdir -p .opencode/agents .opencode/skills

# Add project-specific agents
# These will be available IN ADDITION to global agents
```

---

## Helper Scripts

The scripts from `everything-claude-code/.opencode/scripts/` are in that project.

To use them globally, copy them to your path or create aliases:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/opencode/scripts"

# Or create aliases
alias daily-reflection="$HOME/opencode/scripts/daily-reflection.sh"
alias save-session="$HOME/opencode/scripts/save-session.sh"
```

---

## Configuration File

Global configuration is at: `~/.config/opencode/opencode.json`

This tells OpenCode:
- Where to find agents: `~/.config/opencode/agents`
- Where to find skills: `~/.config/opencode/skills`
- Where to find templates: `~/.config/opencode/context-templates`
- Default agent settings and permissions

---

## Verification

Test that your global setup works:

```bash
# 1. Check agents exist
ls ~/.config/opencode/agents/
# Should see: planner.md, architect.md, tdd-guide.md, code-reviewer.md, security-reviewer.md

# 2. Check skills exist
ls ~/.config/opencode/skills/
# Should see: coding-standards, backend-patterns, frontend-patterns, etc.

# 3. Check config exists
cat ~/.config/opencode/opencode.json
# Should see configuration with agents_path and skills_paths

# 4. Start OpenCode anywhere
cd /tmp
opencode

# 5. Try invoking agent
@planner test
# Should work!
```

---

## Summary

**You DO NOT need to copy agents/skills to every project!**

Your setup is **global** and works in:
- ✅ New projects
- ✅ Existing projects
- ✅ Any directory on your machine
- ✅ All projects using OpenCode

Just `opencode` and start using `@agent-name`!

---

**Questions?**
- See migration guide: `~/Repros/everything-claude-code/docs/MIGRATION_PLAN.md`
- See reference: `~/Repros/everything-claude-code/docs/OPENCODE_REFERENCE.md`
