#!/bin/bash
# Iterative Retrieval Helper
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
