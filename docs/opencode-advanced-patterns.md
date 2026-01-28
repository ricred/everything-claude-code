# Advanced Patterns for OpenCode

## Problem

OpenCode **cannot natively support** Claude Code's advanced orchestration patterns:

**Claude Code Advanced Patterns:**
- Iterative Retrieval - Automatic context refinement
- Continuous Learning - Automatic pattern extraction
- Multi-Agent Orchestration - Automatic coordination

**OpenCode Limitations:**
- No automatic context retrieval
- No automatic learning system
- Manual agent coordination required
- Session-based (no cross-session automation)

## Solution: Manual Pattern Implementation

### 1. Iterative Retrieval Pattern

**Goal:** Progressively refine context retrieval to solve the subagent context problem.

**Claude Code:** Automatic 4-phase loop (dispatch → evaluate → refine → loop)

**OpenCode:** Manual execution using @architect agent

#### Manual Iterative Retrieval Workflow

```
CYCLE 1: Broad Search
├─────────────────────────────┤
1. Define initial broad query
2. Search codebase for patterns
3. Identify candidate files
4. Evaluate relevance (0-1 scale)
5. Document missing context
```

```markdown
[ITERATIVE RETRIEVAL - CYCLE 1]

Task: [description]

Initial Broad Search:
- Patterns: [src/**/*.ts, lib/**/*.ts, etc.]
- Keywords: [keyword1, keyword2, keyword3]
- Excludes: [*.test.ts, *.spec.ts, node_modules]

Search Results:
1. File: [path]
   Relevance: [0.0-1.0]
   Reason: [why relevant]
   Missing: [what context still needed]

2. File: [path]
   Relevance: [0.0-1.0]
   Reason: [why relevant]
   Missing: [what context still needed]

Decision: Continue to CYCLE 2 (need more context)
```

```
CYCLE 2: Refined Search
├─────────────────────────────┤
1. Add new patterns from high-relevance files
2. Add discovered terminology
3. Exclude confirmed irrelevant paths
4. Search refined criteria
5. Evaluate again
```

```markdown
[ITERATIVE RETRIEVAL - CYCLE 2]

Refined Search:
- Added patterns: [new patterns from cycle 1]
- Added keywords: [new terminology discovered]
- Excludes: [low-relevance files from cycle 1]
- Focus areas: [specific gaps identified]

Search Results:
1. File: [path]
   Relevance: [0.0-1.0]
   Reason: [why relevant]
   Missing: [what context still needed]

2. File: [path]
   Relevance: [0.0-1.0]
   Reason: [why relevant]
   Missing: [what context still needed]

Decision: Continue to CYCLE 3 (still missing critical context)
```

```
CYCLE 3: Targeted Search
├─────────────────────────────┤
1. Target specific gaps
2. Search narrow patterns
3. Final evaluation
4. Stop if sufficient context
```

```markdown
[ITERATIVE RETRIEVAL - CYCLE 3]

Targeted Search:
- Target gaps: [specific missing contexts from cycle 2]
- Narrow patterns: [specific directories/files]
- Keywords: [gap-specific terms]

Search Results:
1. File: [path]
   Relevance: [0.7+] HIGH
   Reason: [why critical]
   Complete: [yes/no]

2. File: [path]
   Relevance: [0.7+] HIGH
   Reason: [why critical]
   Complete: [yes/no]

Decision: SUFFICIENT CONTEXT - 2+ high-relevance files
PROCEED WITH TASK
```

#### Relevance Scoring Guide

| Score | Relevance | Action |
|--------|------------|--------|
| 0.0-0.2 | None | Exclude from next cycle |
| 0.2-0.4 | Low | May exclude |
| 0.4-0.6 | Medium | Keep if context needed |
| 0.6-0.7 | Good | Keep |
| 0.7-0.9 | High | Critical - prioritize |
| 0.9-1.0 | Very High | Essential |

#### Stopping Criteria

**Stop iterative retrieval when:**
- 3+ files with relevance ≥ 0.7
- No critical gaps identified
- Maximum 3 cycles reached

**Continue retrieval when:**
- < 3 high-relevance files
- Critical gaps remain
- Cycle < 3

#### Example: Bug Fix Context Retrieval

```bash
# Task: Fix authentication token expiry bug

# CYCLE 1: Manual search
opencode
[ITERATIVE RETRIEVAL - CYCLE 1]
Task: Fix authentication token expiry bug

Initial Search:
- Keywords: token, auth, expiry, session, jwt
- Patterns: src/**/*.ts, lib/**/*.ts
- Excludes: *.test.ts

Results:
1. src/auth/tokens.ts - Relevance: 0.9 (directly implements tokens)
2. src/middleware/auth.ts - Relevance: 0.8 (uses tokens)
3. src/utils/jwt.ts - Relevance: 0.7 (JWT library)

Missing: How expiry is configured, where validation happens

# CYCLE 2: Refined search
[Add keywords: validate, config, expir*, ttl]

Results:
1. src/auth/config.ts - Relevance: 0.85 (has expiry config)
2. src/middleware/validation.ts - Relevance: 0.75 (validates tokens)

Missing: Where tokens are refreshed

# CYCLE 3: Targeted search
[Keywords: refresh, renew, extend]

Results:
1. src/auth/refresh.ts - Relevance: 0.9 (refresh logic)

Decision: SUFFICIENT CONTEXT (5 high-relevance files)
```

#### Agent Support

Use **@architect** agent to guide iterative retrieval:

```bash
opencode --agent @architect
"I need to understand authentication token expiry bug context.
Use iterative retrieval:
1. Search for token, auth, expiry keywords
2. Evaluate relevance (0-1 scale)
3. Refine search based on findings
4. Continue for max 3 cycles or until 3+ high-relevance files found.
Report final context files with relevance scores."
```

### 2. Continuous Learning Manual System

**Goal:** Extract reusable patterns from sessions without automatic hooks.

**Claude Code:** Automatic observation → pattern detection → skill extraction

**OpenCode:** Manual daily reflection → pattern extraction → skill creation

#### Manual Continuous Learning Workflow

```
DAILY REFLECTION (Manual)
├─────────────────────────────┤
1. Review today's sessions
2. Identify successful approaches
3. Document failed attempts
4. Extract reusable patterns
5. Save to learned skills
```

#### Daily Reflection Template

```markdown
# Daily Reflection: [YYYY-MM-DD]

## Sessions Today
1. Session: [topic]
   Duration: [X hours]
   Outcome: [success/partial/failed]
   Key learning: [what I learned]

2. Session: [topic]
   Duration: [X hours]
   Outcome: [success/partial/failed]
   Key learning: [what I learned]

## Patterns I Used Effectively
1. Pattern: [name]
   Context: [when I used it]
   Why it worked: [reason]
   Confidence: [high/medium/low]
   Will use again: [yes/no]

2. Pattern: [name]
   Context: [when I used it]
   Why it worked: [reason]
   Confidence: [high/medium/low]
   Will use again: [yes/no]

## What Didn't Work
1. Approach: [what I tried]
   Why it failed: [reason]
   Alternative I found: [what to do instead]
   Lesson learned: [takeaway]

2. Approach: [what I tried]
   Why it failed: [reason]
   Alternative I found: [what to do instead]
   Lesson learned: [takeaway]

## Project-Specific Conventions Discovered
1. Convention: [description]
   Example: [code example]
   Why project uses this: [reason]
   Where this matters: [files/areas]

2. Convention: [description]
   Example: [code example]
   Why project uses this: [reason]
   Where this matters: [files/areas]

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

2. Pattern: [name]
   Trigger: [when to apply]
   Implementation: [code/algorithm]
   Why it works: [explanation]
   Ready to extract: [yes/no]

## Tomorrow's Focus
- [ ] [Priority 1]
- [ ] [Priority 2]
- [ ] [Priority 3]
```

#### Skill Extraction Process

When a pattern is "ready to extract", create a new skill:

```bash
# Create learned skills directory
mkdir -p ~/.config/opencode/skills/learned

# Create skill file
cat > ~/.config/opencode/skills/learned/pattern-name.md << 'EOF'
---
name: learned-pattern-name
description: [brief description of pattern]
trigger: [when to activate this skill]
confidence: [0.3-0.9]
---

# [Pattern Name]

## When to Activate
- [ ] [Condition 1]
- [ ] [Condition 2]
- [ ] [Condition 3]

## The Pattern
\`\`\`[language]
[Code example showing pattern]
\`\`\`

## Why It Works
[Explanation of why this approach is effective]

## Trade-offs
**Pros:**
- [ ] [Advantage 1]
- [ ] [Advantage 2]

**Cons:**
- [ ] [Disadvantage 1]
- [ ] [Disadvantage 2]

## When Not to Use
Don't use this pattern when:
- [ ] [Exception 1]
- [ ] [Exception 2]

## Confidence Score: [0.3-0.9]
Based on:
- Observation count: [how many times seen]
- Success rate: [X% successful]
- User validation: [yes/no]

## Source
- Discovered: [YYYY-MM-DD]
- Context: [what was being worked on]
- Previous attempts: [what didn't work before]
EOF
```

#### Confidence Scoring System

| Score | Meaning | Behavior |
|--------|---------|----------|
| 0.3 | Tentative | Suggest when relevant, don't enforce |
| 0.5 | Moderate | Apply when relevant patterns match |
| 0.7 | Strong | Default to this pattern for matching scenarios |
| 0.9 | Near-certain | Always use this pattern when applicable |

**Increase confidence when:**
- Pattern works successfully multiple times
- User doesn't correct the pattern
- Multiple scenarios confirm effectiveness

**Decrease confidence when:**
- User explicitly corrects approach
- Pattern fails to solve problem
- Better alternative is discovered

#### Learning Rhythm

```bash
# Daily routine (end of workday)
opencode/scripts/daily-reflection.sh

# Weekly routine (Friday)
opencode/scripts/weekly-pattern-extraction.sh

# Monthly routine (last day)
opencode/scripts/monthly-skill-consolidation.sh
```

#### Example: Learning from Bug Fix

```markdown
# Daily Reflection: 2025-01-28

## Sessions Today
1. Session: Fix authentication token expiry
   Duration: 2 hours
   Outcome: Success
   Key learning: Token expiry was in wrong timezone

## Patterns I Used Effectively
1. Pattern: Timezone-aware timestamp comparison
   Context: Comparing JWT expiry with current time
   Why it worked: Using UTC for all timestamps
   Confidence: 0.9 (worked perfectly)
   Will use again: Yes

## What Didn't Work
1. Approach: Direct timestamp comparison
   Why it failed: Server timezone vs client timezone mismatch
   Alternative I found: Convert all to UTC before comparison
   Lesson learned: Always work in UTC for timestamps

## New Skills Created
- [ ] Created skill: timezone-timestamp-handling
   Path: ~/.config/opencode/skills/learned/timezone-timestamp-handling.md
   Trigger: When comparing timestamps, JWT expiry checks
   Confidence: 0.9
```

Extracted skill:

```markdown
---
name: timezone-timestamp-handling
description: Always use UTC for timestamp comparisons to avoid timezone issues
trigger: When comparing timestamps, JWT expiry checks, date calculations
confidence: 0.9
---

# Timezone-Aware Timestamp Handling

## When to Activate
- Comparing JWT expiry with current time
- Calculating time differences
- Storing timestamps
- Comparing user-provided dates

## The Pattern
\`\`\`typescript
// WRONG: Using server timezone
if (token.expiry < Date.now()) {
  // This can fail due to timezone mismatch
}

// CORRECT: Convert to UTC first
const now = new Date()
const nowUTC = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds())
if (token.expiry < nowUTC.getTime()) {
  // Reliable comparison
}
\`\`\`

## Why It Works
- UTC eliminates timezone ambiguity
- All comparisons use same reference point
- Consistent regardless of server location
- Prevents daylight saving time issues

## Trade-offs
**Pros:**
- Reliable timestamp comparisons
- No timezone-related bugs
- Standard practice in authentication

**Cons:**
- Requires explicit UTC conversion
- Need to display in user timezone separately

## When Not to Use
Don't convert to UTC when:
- Displaying dates to users (use local timezone)
- Storing user preferences (keep their timezone)
- Logging timestamps (store both UTC and local)

## Confidence Score: 0.9
Based on:
- Observation count: 5 instances across different codebases
- Success rate: 100% (no timezone bugs since)
- User validation: Confirmed by production monitoring

## Source
- Discovered: 2025-01-28
- Context: Fixing authentication token expiry bug
- Previous attempts: Direct comparison failed in production
```

### 3. Sequential Agent Orchestration

**Goal:** Coordinate multiple agents to solve complex problems.

**Claude Code:** Automatic task splitting → parallel agent execution → result synthesis

**OpenCode:** Manual task splitting → manual parallel sessions → manual synthesis

#### Manual Sequential Orchestration Workflow

```
PLANNING PHASE
├─────────────────────────────┤
1. Define complex problem
2. Break into sub-tasks
3. Assign sub-tasks to agents
4. Set up parallel sessions
```

```bash
# Example: Complex refactoring task

# Session 1: Planning
opencode --agent @planner
"Plan complex refactoring of authentication system.
Break into sub-tasks that can be done in parallel:
1. Security review
2. Performance analysis
3. Architecture assessment
4. Code quality review
5. Documentation check

For each sub-task, identify:
- Best agent to handle it
- Dependencies (if any)
- Expected output"
```

```
PARALLEL EXECUTION PHASE
├─────────────────────────────┤
1. Start multiple OpenCode sessions
2. Each session runs one sub-task
3. No blocking between sessions
4. Each session uses dedicated agent
```

```bash
# Terminal 1: Security review
opencode --agent @security-reviewer
"Review authentication system for security vulnerabilities.
Focus on:
- SQL injection
- XSS
- CSRF
- Secret management
- Token handling
Output: Security issues found with severity ratings."

# Terminal 2: Performance analysis
opencode --agent @architect
"Analyze authentication system for performance.
Focus on:
- Database queries
- Caching strategy
- Token validation overhead
- Session management
Output: Performance bottlenecks and recommendations."

# Terminal 3: Code quality review
opencode --agent @code-reviewer
"Review authentication system code quality.
Focus on:
- Code organization
- Error handling
- Type safety
- Testing coverage
Output: Quality issues with priorities (CRITICAL/HIGH/MEDIUM/LOW)."

# Terminal 4: Documentation check
opencode --agent @architect
"Review authentication system documentation.
Focus on:
- Architecture completeness
- API documentation
- Setup instructions
- Troubleshooting guide
Output: Missing documentation sections."
```

```
SYNTHESIS PHASE
├─────────────────────────────┤
1. Collect results from all sessions
2. Synthesize into cohesive plan
3. Identify conflicts/dependencies
4. Create unified recommendations
```

```markdown
[AGENT SYNTHESIS: Authentication System Refactoring]

## Security Review Results
[Copy from Terminal 1]

Issues:
1. [CRITICAL] SQL injection vulnerability in login query
   File: src/auth/login.ts:45
   Fix: Use parameterized query
2. [HIGH] XSS risk in error messages
   File: src/auth/errors.ts:12
   Fix: Sanitize error messages
3. [MEDIUM] Missing rate limiting on login endpoint
   File: src/api/auth.ts:23
   Fix: Add rate limiter

## Performance Analysis Results
[Copy from Terminal 2]

Bottlenecks:
1. [HIGH] N+1 query in user lookup
   File: src/repositories/user.ts:34
   Fix: Batch fetch users
2. [MEDIUM] No caching of token validation
   File: src/middleware/auth.ts:67
   Fix: Cache validated tokens in Redis
3. [LOW] Redundant JWT verification
   File: src/utils/jwt.ts:23
   Fix: Cache verification results

## Code Quality Review Results
[Copy from Terminal 3]

Issues:
1. [CRITICAL] Unhandled promise rejection
   File: src/auth/jwt.ts:56
   Fix: Add error handler
2. [HIGH] Missing type guards
   File: src/middleware/auth.ts:89
   Fix: Add runtime type checking
3. [MEDIUM] Inconsistent error handling
   File: src/auth/*.ts (multiple files)
   Fix: Centralize error handling

## Documentation Review Results
[Copy from Terminal 4]

Missing Documentation:
1. [HIGH] Architecture diagram
2. [MEDIUM] API endpoint documentation
3. [LOW] Troubleshooting guide
4. [LOW] Performance tuning guide

## Unified Recommendations

Priority 1: Security Fixes
1. Fix SQL injection in login query (CRITICAL)
2. Add rate limiting (MEDIUM)
3. Sanitize error messages (HIGH)

Priority 2: Performance Improvements
1. Batch fetch users (HIGH)
2. Add token caching (MEDIUM)
3. Remove redundant JWT verification (LOW)

Priority 3: Code Quality
1. Fix unhandled promise rejection (CRITICAL)
2. Add type guards (HIGH)
3. Centralize error handling (MEDIUM)

Priority 4: Documentation
1. Create architecture diagram (HIGH)
2. Document API endpoints (MEDIUM)

## Implementation Order
1. Week 1: Critical security + performance fixes
2. Week 2: Code quality improvements
3. Week 3: Documentation updates

## Agent Coordination Notes
- No conflicts between agent recommendations
- All agents agree on security priority
- Performance and security goals aligned
- Documentation can proceed in parallel
```

#### Parallel vs Sequential Selection

**Use Parallel Execution When:**
- Sub-tasks are independent (no dependencies)
- Agents work on different aspects (security, performance, quality)
- Time-critical (need results quickly)
- No resource conflicts (all agents can access same files)

**Use Sequential Execution When:**
- Sub-tasks have dependencies
- Agents need results from previous tasks
- Resource constraints (limited system resources)
- Complex coordination needed

#### Coordination Pattern

```bash
# Pattern for complex tasks

# Step 1: Plan
SESSION_A=$(opencode --agent @planner "Plan task: $TASK")

# Step 2: Execute in parallel
SESSION_B=$(opencode --agent @security-reviewer "Subtask 1: Security analysis") &
SESSION_C=$(opencode --agent @architect "Subtask 2: Architecture review") &
SESSION_D=$(opencode --agent @code-reviewer "Subtask 3: Code quality") &

# Step 3: Wait for completion
wait

# Step 4: Synthesize
opencode "Synthesize results from parallel agents:
1. Security findings
2. Architecture recommendations
3. Code quality issues
Create unified refactoring plan."
```

### 4. Integration with Existing OpenCode Features

#### AGENTS.md Initialization

Create project-specific `AGENTS.md` with pattern guidance:

```markdown
# Project: Everything Claude Code (OpenCode Edition)

## Recommended Patterns

### Iterative Retrieval
Use for complex tasks requiring deep context understanding:
1. Start with broad search
2. Evaluate relevance (0-1 scale)
3. Refine based on findings
4. Continue for max 3 cycles or until 3+ high-relevance files

Trigger: Use when task > 1 file or requires > 200 lines of context
Example: Bug fixes, architecture changes, refactoring

### Continuous Learning
Daily reflection at end of workday:
1. Review sessions
2. Identify effective patterns
3. Extract reusable skills
4. Save to ~/.config/opencode/skills/learned/

Trigger: End of each workday
Tool: ~/.config/opencode/scripts/daily-reflection.sh

### Agent Orchestration
For complex problems, use parallel agents:
1. @planner - Break into sub-tasks
2. Parallel sessions - Execute independently
3. Synthesis phase - Combine results
4. Create unified plan

Trigger: Tasks requiring multiple perspectives
Example: Security + Performance + Quality review
```

#### Context Templates Integration

Update context templates to include pattern guidance:

```markdown
# [DEVELOPMENT MODE - With Pattern Guidance]

## Patterns to Use
1. **Iterative Retrieval** - For complex context needs
2. **Continuous Learning** - Daily reflection
3. **Agent Orchestration** - For complex tasks

## Workflow
- Write code first, explain after
- Use @tdd-guide for new features
- Use @code-reviewer after implementation
- Daily: Use continuous learning patterns
- For bugs: Use iterative retrieval to understand context
```

## Limitations

What we've **lost** vs Claude Code:
- ❌ Automatic iterative retrieval (now manual)
- ❌ Automatic continuous learning (now manual)
- ❌ Automatic agent orchestration (now manual)

What we've **retained**:
- ✅ Same agent capabilities (via @mention)
- ✅ Same skill library (via manual discovery)
- ✅ Same quality standards (via manual enforcement)
- ✅ Same context preservation goals (via manual workflows)

## Best Practices

1. **Use iterative retrieval** for complex tasks (>1 file context needs)
2. **Daily reflection** for continuous learning (end of workday)
3. **Parallel agents** for independent sub-tasks
4. **Manual synthesis** to combine agent results
5. **Document patterns** as you discover them
6. **Use AGENTS.md** to embed pattern guidance in projects

## Next Steps

- [ ] Create helper scripts for pattern workflows
- [ ] Set up daily reflection automation
- [ ] Create parallel execution helper scripts
- [ ] Document complex pattern examples

---

**Remember**: OpenCode supports the same advanced patterns - they just require manual execution. The quality and depth of patterns remains identical.
