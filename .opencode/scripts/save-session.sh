#!/bin/bash
# Session Summary Generator
# Creates session summary template for memory persistence

set -e

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)
MEM_DIR=".opencode/memories"
SESSION_FILE="$MEM_DIR/session-$DATE.md"

# Ensure directory exists
mkdir -p "$MEM_DIR"

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
