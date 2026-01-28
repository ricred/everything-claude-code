# Scripts & Utilities Migration to OpenCode

## Problem

Most scripts in `scripts/` directory **depend on Claude Code APIs**:

**Claude Code Scripts Depend On:**
- `process.env.CLAUDE_SESSION_ID` - Session tracking
- PreToolUse/PostToolUse hooks - Event triggers
- Stop hooks - Session end events
- Claude Code's environment - API calls

**OpenCode Limitations:**
- No `CLAUDE_SESSION_ID` or equivalent
- No PreToolUse/PostToolUse hooks
- No Stop hooks
- No session tracking API
- Different environment structure

## Solution: Adapt or Replace

### 1. Package Manager Script

**Status:** ✅ **COMPATIBLE** - Can be used with OpenCode

The package manager detection and selection logic is **environment-agnostic**:

```bash
# Works with OpenCode
node scripts/setup-package-manager.js --detect
node scripts/setup-package-manager.js --global pnpm
node scripts/setup-package-manager.js --project bun
```

**No changes needed** - Script works as-is.

**Usage:**
```bash
# Detect package manager
node scripts/setup-package-manager.js --detect

# Set global preference (saves to ~/.claude/)
node scripts/setup-package-manager.js --global pnpm

# Set project preference (saves to .claude/)
node scripts/setup-package-manager.js --project bun

# List available
node scripts/setup-package-manager.js --list
```

### 2. Hook Scripts (Need Replacement)

**Status:** ❌ **NOT COMPATIBLE** - Require Claude Code's hook system

These scripts **cannot work** with OpenCode:
- `suggest-compact.js` - Uses PreToolUse hook
- `check-console-log.js` - Uses PreToolUse/PostToolUse hooks
- `session-end.js` - Uses Stop hook
- `session-start.js` - Uses session start event
- `evaluate-session.js` - Uses Stop hook
- `pre-compact.js` - Uses PreToolUse hook

**Replacement:** Manual workflow scripts for OpenCode

### 3. OpenCode-Compatible Helper Scripts

Create new scripts in `.opencode/scripts/` that work without hooks:

#### Script: Daily Reflection (continuous-learning)

```bash
#!/bin/bash
# .opencode/scripts/daily-reflection.sh
# Creates daily reflection template for continuous learning

set -e

DATE=$(date +%Y-%m-%d)
SESSION_FILE="$HOME/.opencode/memories/session-$DATE.md"
TEMPLATE_DIR="$HOME/.config/opencode/context-templates"

# Ensure directory exists
mkdir -p "$(dirname "$SESSION_FILE")"

# Create daily reflection
cat << 'EOF' > "$SESSION_FILE"
# Daily Reflection: $DATE

## Sessions Today
1. Session: [topic]
   Duration: [X hours]
   Outcome: [success/partial/failed]
   Key learning: [what I learned]

## Patterns I Used Effectively
1. Pattern: [name]
   Context: [when I used it]
   Why it worked: [reason]
   Confidence: [high/medium/low]
   Will use again: [yes/no]

## What Didn't Work
1. Approach: [what I tried]
   Why it failed: [reason]
   Alternative I found: [what to do instead]
   Lesson learned: [takeaway]

## Project-Specific Conventions Discovered
1. Convention: [description]
   Example: [code example]
   Why project uses this: [reason]

## New Skills Created
- [ ] Created skill: [name]
   Path: [~/.config/opencode/skills/learned/skill-name.md]
   Trigger: [when to use]
   Confidence: [high/medium/low]

## Patterns to Extract as Skills
1. Pattern: [name]
   Trigger: [when to apply]
   Implementation: [code/algorithm]
   Why it works: [explanation]
   Ready to extract: [yes/no]

## Tomorrow's Focus
- [ ] [Priority 1]
- [ ] [Priority 2]
- [ ] [Priority 3]
EOF

echo "Daily reflection template created: $SESSION_FILE"
echo "Edit it to add details from today's sessions."
echo ""
echo "To add to continuous learning:"
echo "  1. Review the template"
echo "  2. Identify reusable patterns"
echo "  3. Extract as skills to ~/.config/opencode/skills/learned/"
```

#### Script: Session Summary Generator

```bash
#!/bin/bash
# .opencode/scripts/save-session.sh
# Generates session summary template

set -e

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
SESSION_FILE=".opencode/memories/session-$DATE.md"

# Ensure directory exists
mkdir -p .opencode/memories

# Generate session summary template
cat << 'EOF' > "$SESSION_FILE"
# Session Summary: $DATE $TIME

## What We Did
[Fill in what was accomplished today]

## Key Decisions
1. Decision: [description]
   Reason: [why]
   Alternative considered: [what else]

## Patterns Used
1. Pattern: [name]
   File: [path]
   Reason: [why this pattern]

## Issues & Solutions
- Issue: [problem]
   Solution: [how fixed]
   Lesson learned: [what to remember]

## Files Modified
\`\`\`bash
git diff --name-only HEAD~1
\`\`\`

## Next Steps
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]

## Context for Future
- Important: [critical context to remember]
- Patterns: [project-specific patterns]
- Gotchas: [tricky things to watch out for]
EOF

echo "Session template created: $SESSION_FILE"
echo "Edit to add details, then commit if desired."
```

#### Script: Context Reset Helper

```bash
#!/bin/bash
# .opencode/scripts/reset-context.sh
# Prompts for compaction type and shows relevant template

echo "Choose compaction type:"
echo "1) After Exploration"
echo "2) After Milestone"
echo "3) Context Switch"
echo "4) Full Reset"
echo ""
read -p "Select [1-4]: " choice

TEMPLATE_DIR="$HOME/.config/opencode/context-templates"

case $choice in
  1)
    cat "$TEMPLATE_DIR/compact-exploration.txt"
    ;;
  2)
    cat "$TEMPLATE_DIR/compact-milestone.txt"
    ;;
  3)
    cat "$TEMPLATE_DIR/compact-switch.txt"
    ;;
  4)
    echo "[COMPACT: FULL RESET - Starting fresh session]"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac
```

#### Script: Load Relevant Memory

```bash
#!/bin/bash
# .opencode/scripts/load-memory.sh
# Lists available session memories and lets user choose one to load

MEM_DIR="$HOME/.opencode/memories"

if [[ ! -d "$MEM_DIR" ]]; then
  echo "No memories directory found at $MEM_DIR"
  echo "Create session summaries to build memory."
  exit 1
fi

echo "Available session memories:"
echo ""

# List sessions with numbers
i=1
for file in $(ls -t "$MEM_DIR"/session-*.md 2>/dev/null); do
  if [[ -f "$file" ]]; then
    basename "$file"
    ((i++))
  fi
done | nl

if [[ $i -eq 1 ]]; then
  echo "No session memories found."
  echo "Create session summaries to build memory."
  exit 0
fi

echo ""
read -p "Enter number to view memory (or Ctrl+C to skip): " num

if [[ -n "$num" && "$num" =~ ^[0-9]+$ ]]; then
  file=$(ls -t "$MEM_DIR"/session-*.md 2>/dev/null | sed "${num}q;d")
  if [[ -f "$file" ]]; then
    echo ""
    echo "=== $(basename "$file") ==="
    echo ""
    cat "$file"
  fi
fi
```

#### Script: Iterative Retrieval Helper

```bash
#!/bin/bash
# .opencode/scripts/iterative-retrieval.sh
# Guides user through manual iterative retrieval process

set -e

echo "=== ITERATIVE RETRIEVAL WORKFLOW ==="
echo ""
echo "Task: Describe your task below (press Enter when done)"
read -p "> " task_description

cat << 'EOF'

CYCLE 1: Broad Search
├─────────────────────────────┤
1. Define initial broad query
2. Search codebase for patterns
3. Identify candidate files
4. Evaluate relevance (0-1 scale)
5. Document missing context

Example Broad Search:
- Patterns: src/**/*.ts, lib/**/*.ts
- Keywords: [keyword1, keyword2, keyword3]
- Excludes: *.test.ts, *.spec.ts, node_modules

Decision Points:
- Continue to CYCLE 2 if < 3 high-relevance (≥0.7) files
- Continue to CYCLE 2 if critical gaps remain
- STOP if sufficient context (≥3 high-relevance files)

CYCLE 2: Refined Search
├─────────────────────────────┤
1. Add new patterns from high-relevance files
2. Add discovered terminology
3. Exclude confirmed irrelevant paths
4. Search refined criteria
5. Evaluate again

Decision Points:
- Continue to CYCLE 3 if < 3 high-relevance (≥0.7) files
- Continue to CYCLE 3 if critical gaps remain
- STOP if sufficient context (≥3 high-relevance files)

CYCLE 3: Targeted Search
├─────────────────────────────┤
1. Target specific gaps
2. Search narrow patterns
3. Final evaluation
4. STOP (max 3 cycles reached)

Decision Points:
- STOP regardless (maximum 3 cycles)
- STOP if sufficient context (≥3 high-relevance files)

RELEVANCE SCORING:
├─────────────────────────────┤
0.0-0.2: None - Exclude from next cycle
0.2-0.4: Low - May exclude
0.4-0.6: Medium - Keep if context needed
0.6-0.7: Good - Keep
0.7-0.9: High - Critical, prioritize
0.9-1.0: Very High - Essential

STOPPING CRITERIA:
├─────────────────────────────┤
STOP when:
- 3+ files with relevance ≥ 0.7
- No critical gaps identified
- Maximum 3 cycles reached

CONTINUE when:
- < 3 high-relevance files
- Critical gaps remain
- Cycle < 3
EOF

echo ""
echo "Your task: $task_description"
echo ""
echo "Start CYCLE 1 by running @architect agent with your task."
```

### 4. Cross-Platform Utility Adaptation

The `lib/utils.js` file has many utility functions. Extract the **environment-agnostic** ones:

#### Compatible Functions (No Claude Code API)

```bash
# These work with OpenCode - no Claude-specific APIs:

# Platform detection
- isWindows, isMacOS, isLinux

# Directory operations (cross-platform)
- ensureDir()
- getHomeDir()

# Date/time utilities
- getDateString()
- getTimeString()

# File operations
- readFile()
- writeFile()
- replaceInFile()

# Git operations
- isGitRepo()
- getGitModifiedFiles()
```

#### Incompatible Functions (Need Replacement)

```bash
# These depend on Claude Code environment:

# Session ID (Claude-specific)
- getSessionIdShort()
  REPLACEMENT: Use timestamp or custom ID

# Hook I/O (Claude-specific)
- readStdinJson()
- log() (as Claude visible output)
  REPLACEMENT: Direct file I/O, standard output
```

### 5. Creating OpenCode Scripts Directory

```bash
# Create scripts directory
mkdir -p .opencode/scripts

# Copy adapted scripts
# (From examples above)

# Make executable
chmod +x .opencode/scripts/*.sh

# Add to PATH (optional)
export PATH="$PATH:$(pwd)/.opencode/scripts"
```

### 6. Script Integration with OpenCode

#### Usage in OpenCode Sessions

```bash
# Start of day
.opencode/scripts/daily-reflection.sh
# [Edit generated template]

# During work
.opencode/scripts/reset-context.sh
# [Select compaction type, paste into OpenCode]

# Load previous context
.opencode/scripts/load-memory.sh
# [Select memory to load]

# For complex context needs
.opencode/scripts/iterative-retrieval.sh
# [Follow the workflow with @architect]

# End of day
.opencode/scripts/save-session.sh
# [Edit template with session details]
```

### 7. Scripts Migration Status

| Script | Status | OpenCode Alternative |
|---------|----------|---------------------|
| `setup-package-manager.js` | ✅ Compatible | No changes needed |
| `lib/utils.js` (cross-platform) | ✅ Compatible | Extract generic functions |
| `hooks/suggest-compact.js` | ❌ Not Compatible | Manual prompts + reset-context.sh |
| `hooks/check-console-log.js` | ❌ Not Compatible | Manual review with code-reviewer |
| `hooks/session-end.js` | ❌ Not Compatible | save-session.sh |
| `hooks/session-start.js` | ❌ Not Compatible | load-memory.sh |
| `hooks/evaluate-session.js` | ❌ Not Compatible | daily-reflection.sh |
| `hooks/pre-compact.js` | ❌ Not Compatible | reset-context.sh |

## Limitations

What we've **lost** vs Claude Code:
- ❌ Automatic hook-based execution
- ❌ Session ID tracking (CLAUDE_SESSION_ID)
- ❌ Automatic compaction suggestions
- ❌ Automatic session start/end detection
- ❌ Claude-visible log() output

What we've **retained**:
- ✅ Package manager detection (works everywhere)
- ✅ Cross-platform utilities (generic functions)
- ✅ Same script capabilities (manual execution)
- ✅ Same workflow patterns (manual triggers)

## Best Practices

1. **Manual script execution** - Run scripts before/after sessions
2. **Session summaries** - Use save-session.sh at day's end
3. **Context management** - Use reset-context.sh strategically
4. **Memory building** - Use load-memory.sh at session start
5. **Continuous learning** - Use daily-reflection.sh daily

## Next Steps

- [ ] Create .opencode/scripts/ directory
- [ ] Adapt all utility functions
- [ ] Create helper scripts listed above
- [ ] Test scripts on different platforms
- [ ] Document usage in README

---

**Remember**: OpenCode's environment is different - adapt scripts to be manual, not automated. The capabilities remain same - execution is now user-initiated.
