# Hooks Alternative System for OpenCode

## Problem

OpenCode **does not support event-driven hooks** like Claude Code:

**Claude Code Hooks:**
- `PreToolUse` - Runs before every tool call
- `PostToolUse` - Runs after every tool call
- `Stop` - Runs at session end
- Automatic triggers based on patterns

**OpenCode:**
- ❌ No native hook system
- ❌ No automatic event triggers
- ❌ No pre/post tool call actions
- Manual workflow orchestration only

## Solution: Manual Workflow Patterns

### 1. Memory Persistence

**Goal:** Save important context to reuse in future sessions.

#### Pattern: Save Context Manually

**When to Save:**
- After completing complex features
- After debugging difficult issues
- After architectural decisions
- Before major context switches

**What to Save:**
```markdown
## Session Summary: [Feature Name]

### What We Did
- [ ] Implemented X
- [ ] Fixed Y
- [ ] Decided on architecture Z

### Key Decisions
1. Decision: [description]
   Reason: [why]
   Alternative considered: [what else]

### Patterns Used
- Pattern: [name]
   File: [path]
   Reason: [why this pattern]

### Issues & Solutions
- Issue: [problem]
   Solution: [how fixed]
   Lesson learned: [what to remember]

### Files Modified
- [ ] `src/auth.ts` - Added JWT authentication
- [ ] `src/middleware.ts` - Added auth middleware
- [ ] `tests/auth.test.ts` - Added tests

### Next Steps
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

### Context for Future
- Important: [critical context to remember]
- Patterns: [project-specific patterns]
- Gotchas: [tricky things to watch out for]
```

**Save Location:**
```bash
# Create session memory directory
mkdir -p .opencode/memories

# Save session summary
opencode/memories/session-2025-01-28-auth-implementation.md
```

#### Pattern: Load Context at Session Start

**Before starting work:**
```bash
# Check if relevant memory exists
ls .opencode/memories/ | grep -i auth

# Load memory file into OpenCode session
cat .opencode/memories/session-2025-01-28-auth-implementation.md
```

**Example workflow:**
```bash
# 1. Start new session for auth work
opencode

# 2. Load context first
cat .opencode/memories/session-2025-01-28-auth-implementation.md

# 3. Work on feature (memory loaded)
echo "[DEVELOPMENT MODE]"
# ... implement features ...

# 4. At end, update memory
# Edit session-2025-01-28-auth-implementation.md
# Add new decisions, issues, patterns
```

### 2. Manual Compaction Workflows

**Goal:** Clear accumulated context to free tokens for new work.

#### Pattern: Context Reset Prompts

Use these prompts to manually trigger compaction:

##### After Exploration Phase
```markdown
[COMPACT: EXPLORATION COMPLETE]

Exploration phase done. Clear exploration context, keep:
- Final implementation plan
- Architecture decisions
- File structure
- Key patterns to use

Discard:
- Initial research notes
- Dead-end paths explored
- Partial analyses
- Temporary calculations
```

##### After Completing a Milestone
```markdown
[COMPACT: MILESTONE COMPLETE]

Milestone finished. Clear implementation context, keep:
- What was accomplished
- Lessons learned
- Next steps
- Critical context for next phase

Discard:
- Intermediate debugging
- Temporary test code
- Unused experiments
- Exhaustive error messages
```

##### Before Context Switch
```markdown
[COMPACT: SWITCHING CONTEXTS]

Switching from [previous task] to [new task].

Keep:
- High-level project overview
- Critical architectural patterns
- Global project settings
- Active branches/PRs

Discard:
- Previous task details
- Temporary files from previous task
- Task-specific debugging info
- Unused imports/variables
```

#### Pattern: Strategic Compaction Checkpoint

```bash
# Every ~50 tool calls, check if compaction needed
if [[ $(history | wc -l) -gt 50 ]]; then
  echo "[CHECKPOINT: Consider /compact or [COMPACT prompt]"
fi
```

**Manual Compaction Checklist:**

Before compaction:
- [ ] Critical decisions documented
- [ ] Patterns used identified
- [ ] Next steps clear
- [ ] Context summary written

After compaction:
- [ ] Enough context remains for next task
- [ ] No critical information lost
- [ ] Session continues smoothly

### 3. Session-Based Context Preservation

**Goal:** Maintain context across multiple OpenCode sessions.

#### Pattern: Session Handoff File

Create `.opencode/session-handoff.md`:

```markdown
# Session Handoff

## Current Session
- Date: [2025-01-28 12:00]
- Branch: [feature/auth-system]
- Focus: [Implementing JWT authentication]

## Active Work
- Currently working on: [auth middleware]
- Status: [in-progress]
- Next action: [add rate limiting]

## Recent Changes
```
[git log -5 --oneline]
```

## Important Context
1. **Architecture Decision**: Using JWT with httpOnly cookies
   Reason: More secure than localStorage
   Implementation: See `src/auth/jwt.ts`

2. **Key Pattern**: Repository pattern for data access
   Example: `src/repositories/user.repository.ts`

3. **Known Issue**: Token refresh not yet implemented
   Planned fix: Session 2 focus

## Pending Tasks
- [ ] Add token refresh mechanism
- [ ] Implement rate limiting
- [ ] Add E2E tests for auth flow
- [ ] Update documentation

## Environment Variables
```
cat .env.example
```

## Commands to Run
```bash
# Development
npm run dev

# Tests
npm run test
npm run test:e2e

# Build
npm run build
```
```

**Usage:**
```bash
# End of session: Update handoff
# Edit .opencode/session-handoff.md

# Start of new session: Read handoff
cat .opencode/session-handoff.md
```

#### Pattern: AGENTS.md Initialization

OpenCode supports project initialization via `AGENTS.md`:

```markdown
# Project: Everything Claude Code (OpenCode Edition)

## Development Context
This project is being migrated from Claude Code to OpenCode.ai.
Focus: Complete migration and test compatibility.

## Project Standards
- TDD: 80%+ coverage required
- Style: Immutability, small files
- Security: No hardcoded secrets
- Git: Conventional commits

## Available Skills
All skills in `~/.config/opencode/skills/` are available:
- coding-standards
- backend-patterns
- frontend-patterns
- tdd-workflow
- security-review
- golang-patterns
- postgres-patterns
- And more...

## Available Agents
All agents in `~/.config/opencode/agents/` are available:
- @planner - Implementation planning
- @architect - System design
- @tdd-guide - Test-driven development
- @code-reviewer - Code quality review
- @security-reviewer - Security analysis

## Current Focus
Migration in progress:
- ✅ Research & Architecture
- ✅ Agent Conversion
- ✅ Skill Conversion
- ✅ Rules & Contexts
- 🔄 Hooks Alternative System (current)
- ⏳ Advanced Patterns
- ⏳ Scripts Migration
- ⏳ Testing
- ⏳ Release v2.0.0

## Memory
Recent decisions stored in `.opencode/memories/`.
Use context templates from `~/.config/opencode/context-templates/`.
```

### 4. Automated Workaround Scripts

Since OpenCode lacks hooks, create helper scripts:

#### Script: Session Summary Generator

```bash
#!/bin/bash
# .opencode/scripts/save-session.sh

SESSION_FILE=".opencode/memories/session-$(date +%Y-%m-%d-%H%M%S).md"
mkdir -p .opencode/memories

cat << 'EOF' > "$SESSION_FILE"
# Session Summary: $(date '+%Y-%m-%d %H:%M:%S')

## What We Did
[Fill in what was accomplished]

## Key Decisions
[Document architectural decisions made]

## Patterns Used
[List patterns used and why]

## Issues & Solutions
[Document bugs found and how fixed]

## Files Modified
\`\`\`bash
git diff --name-only
\`\`\`

## Next Steps
[ ] [Next task 1]
[ ] [Next task 2]

## Context for Future
[Important context to remember in future sessions]
EOF

echo "Session template created: $SESSION_FILE"
echo "Edit it to add details, then commit."
```

#### Script: Context Reset Helper

```bash
#!/bin/bash
# .opencode/scripts/reset-context.sh

echo "Choose compaction type:"
echo "1) After Exploration"
echo "2) After Milestone"
echo "3) Context Switch"
echo "4) Full Reset"

read -p "Select [1-4]: " choice

case $choice in
  1) cat ~/.config/opencode/context-templates/compact-exploration.txt ;;
  2) cat ~/.config/opencode/context-templates/compact-milestone.txt ;;
  3) cat ~/.config/opencode/context-templates/compact-switch.txt ;;
  4) echo "[COMPACT: FULL RESET - Starting fresh session]" ;;
esac
```

#### Script: Load Relevant Memory

```bash
#!/bin/bash
# .opencode/scripts/load-memory.sh

echo "Available sessions:"
ls -t .opencode/memories/ | nl

read -p "Enter number to load (or Ctrl+C): " num

if [[ -n "$num" ]]; then
  file=$(ls -t .opencode/memories/ | sed "${num}q;d")
  cat ".opencode/memories/$file"
fi
```

### 5. Continuous Learning Manual Workaround

**Goal:** Extract and save learned patterns without automatic hooks.

#### Pattern: Daily Reflection

At end of each day, manually extract patterns:

```markdown
# Daily Reflection: [2025-01-28]

## What I Learned
1. Pattern: [pattern name]
   Context: When I used it
   Why it worked: [reason]
   Will use again: [yes/no]

## What Didn't Work
1. Approach: [what I tried]
   Why it failed: [reason]
   Alternative: [what to do instead]

## Project-Specific Conventions
1. Convention: [description]
   Example: [code example]
   Why project uses this: [reason]

## Tools & Commands
- [ ] New useful command: [command]
- [ ] New useful pattern: [pattern]
- [ ] New useful alias: [alias]

## Tomorrow's Focus
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]
```

#### Pattern: Pattern Extraction

After completing complex work, extract reusable patterns:

```markdown
# Pattern: [Pattern Name]

## Trigger
When to apply this pattern:
- [ ] Condition 1
- [ ] Condition 2

## Implementation
\`\`\`typescript
// Code example
\`\`\`

## Why It Works
[Explanation of why this approach is effective]

## Trade-offs
Pros:
- [ ] Pro 1
- [ ] Pro 2

Cons:
- [ ] Con 1
- [ ] Con 2

## When Not to Use
Don't use this pattern when:
- [ ] Exception 1
- [ ] Exception 2
```

### 6. Workflow Examples

#### Example 1: Multi-Session Feature Development

```bash
# Session 1: Research & Planning
opencode
cat ~/.config/opencode/context-templates/research-mode.txt
# [Explore codebase, understand requirements]
# At end: Save session summary
opencode/scripts/save-session.sh

# Session 2: Implementation (Next day)
opencode
opencode/scripts/load-memory.sh
# [Select previous session]
# [Load development mode context]
cat ~/.config/opencode/context-templates/development-mode.txt
# [Implement feature]
# [Use TDD workflow]
# [At end: Update session summary]

# Session 3: Testing & Refinement
opencode
# [Load session summary]
cat ~/.config/opencode/context-templates/code-review-mode.txt
# [Review code, fix issues]
# [Run tests, verify coverage]
# [At end: Final summary]
```

#### Example 2: Context Reset Mid-Session

```bash
# Working on feature, context getting large (~50 tool calls)
# Time to compact!

cat ~/.config/opencode/context-templates/compact-milestone.txt
# Paste into session
# [Agent clears exploration context, keeps critical info]

# Continue work with fresh context
```

#### Example 3: Bug Investigation Across Sessions

```bash
# Session 1: Debug
opencode
# [Load code review mode]
# [Investigate bug]
# [Try multiple approaches]
# [At end: Document findings in session summary]

# Session 2: Fix
opencode
# [Load session summary from debug session]
# [Load development mode]
# [Implement fix]
# [Test thoroughly]
# [Update session summary with solution]
```

## Comparison: Claude Code Hooks vs OpenCode Manual

| Feature | Claude Code (Hooks) | OpenCode (Manual) |
|----------|---------------------|-------------------|
| Memory persistence | Automatic (Stop hook) | Manual session summaries |
| Compaction | Automatic triggers | Manual prompts/checkpoints |
| Pattern extraction | Automatic (continuous-learning skill) | Manual daily reflection |
| Context switching | Automatic (pre/post hooks) | Manual handoff files |
| Trigger reliability | 100% (hooks always fire) | Human-dependent |

## Limitations

What we've **lost**:
- ❌ Automatic context compaction
- ❌ Automatic pattern learning
- ❌ Event-driven triggers
- ❌ Hook-based orchestration

What we've **retained**:
- ✅ Same quality standards (manual enforcement)
- ✅ Same agent capabilities
- ✅ Same skill library
- ✅ Same context preservation goals

## Best Practices for OpenCode

1. **Manual discipline** - Create session summaries at end of each day
2. **Strategic compaction** - Check context size every 50 tool calls
3. **Load before work** - Always read relevant memory before starting
4. **Document decisions** - Capture architectural decisions immediately
5. **Use AGENTS.md** - Initialize projects with context
6. **Use context templates** - Copy relevant templates at session start

## Next Steps

- [ ] Create helper scripts in `.opencode/scripts/`
- [ ] Set up daily reflection routine
- [ ] Automate session summary generation
- [ ] Create compaction checkpoint reminders

---

**Remember**: OpenCode requires manual workflow orchestration. The patterns remain same - execution is now intentional and manual, not automatic.
