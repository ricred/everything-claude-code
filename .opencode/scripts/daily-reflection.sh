#!/bin/bash
# Daily Reflection for Continuous Learning
# Creates daily reflection template for pattern extraction

set -e

DATE=$(date +%Y-%m-%d)
MEM_DIR="$HOME/.opencode/memories"
SESSION_FILE="$MEM_DIR/session-$DATE.md"

# Ensure directory exists
mkdir -p "$MEM_DIR"

# Create daily reflection template
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
echo "  1. Review template"
echo "  2. Identify reusable patterns"
echo "  3. Extract as skills to ~/.config/opencode/skills/learned/"
