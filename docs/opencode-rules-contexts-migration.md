# Rules & Contexts Migration to OpenCode

## Problem

OpenCode **does not have native equivalents** to Claude Code's `rules/` and `contexts/` systems.

**Claude Code:**
- `rules/*.md` - Automatically enforced patterns
- `contexts/*.md` - Context-aware behavior
- Hooks trigger context switches automatically

**OpenCode:**
- No native rule enforcement system
- No automatic context switching
- Agent selection is manual (@mention)
- Manual workflow orchestration

## Solution: Manual Implementation

### 1. Rule Enforcement via Agent Prompts

Convert rules to **agent-specific instructions** by embedding them in agent definitions:

#### Example: Embed Security Rules in Agents

```markdown
---
mode: subagent
description: Code reviewer with focus on security, performance, and maintainability
---

# Security-First Code Reviewer

## Security Checklist (MANDATORY)

Before any code review, verify:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated (use zod/schema validation)
- [ ] SQL injection prevention (parameterized queries only)
- [ ] XSS prevention (sanitize HTML, use CSP)
- [ ] CSRF protection enabled (SameSite cookies, tokens)
- [ ] Authentication/authorization verified
- [ ] Rate limiting on all endpoints
- [ ] Error messages don't leak sensitive data
```

### 2. Context Switching via Manual Prompts

Create **context prompt templates** users can invoke:

#### Development Context Prompt

```
[DEVELOPMENT MODE]
- Write code first, explain after
- Prefer working solutions over perfect solutions
- Run tests after changes
- Keep commits atomic

Priorities:
1. Get it working
2. Get it right
3. Get it clean
```

#### Research Context Prompt

```
[RESEARCH MODE]
- Read widely before concluding
- Ask clarifying questions
- Document findings as you go
- Don't write code until understanding is clear

Research Process:
1. Understand the question
2. Explore relevant code/docs
3. Form hypothesis
4. Verify with evidence
5. Summarize findings
```

#### Code Review Context Prompt

```
[CODE REVIEW MODE]
- Read thoroughly before commenting
- Prioritize issues by severity (critical > high > medium > low)
- Suggest fixes, don't just point out problems
- Check for security vulnerabilities

Review Checklist:
- [ ] Logic errors
- [ ] Edge cases
- [ ] Error handling
- [ ] Security (injection, auth, secrets)
- [ ] Performance
- [ ] Readability
- [ ] Test coverage
```

### 3. Agent Orchestration via Parallel Sessions

OpenCode supports **multi-session coordination** manually:

```bash
# Terminal 1: Agent 1
opencode --agent @planner "Plan authentication system"

# Terminal 2: Agent 2 (parallel)
opencode --agent @architect "Review authentication architecture"

# Terminal 3: Agent 3 (parallel)
opencode --agent @security-reviewer "Analyze security implications"
```

### 4. Performance Patterns Manual Guidance

**Model Selection Guidelines:**

```markdown
Use Haiku 4.5 for:
- Lightweight agents with frequent invocation
- Pair programming and code generation
- Worker agents in multi-agent systems

Use Sonnet 4.5 for:
- Main development work
- Orchestrating multi-agent workflows
- Complex coding tasks

Use Opus 4.5 for:
- Complex architectural decisions
- Maximum reasoning requirements
- Research and analysis tasks
```

**Context Window Management:**

```markdown
Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity for:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes
```

### 5. Testing Requirements Manual Enforcement

**TDD Workflow:**

```
1. Write test first (RED)
2. Run test - it should FAIL
3. Write minimal implementation (GREEN)
4. Run test - it should PASS
5. Refactor (IMPROVE)
6. Verify coverage (80%+)
```

**Coverage Targets:**

```markdown
- Critical business logic: 100%
- Public APIs: 90%+
- General code: 80%+
- Generated code: Exclude
```

### 6. Git Workflow Manual Enforcement

**Commit Message Format:**

```
<type>: <description>

Types: feat, fix, refactor, docs, test, chore, perf, ci
```

**Feature Implementation Workflow:**

```
1. Plan First
   - Use @planner agent
   - Identify dependencies and risks
   - Break down into phases

2. TDD Approach
   - Use @tdd-guide agent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. Code Review
   - Use @code-reviewer agent
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. Commit & Push
   - Detailed commit messages
   - Follow conventional commits format
```

### 7. Coding Style Manual Guidelines

**Immutability (CRITICAL):**

```javascript
// WRONG: Mutation
function updateUser(user, name) {
  user.name = name  // MUTATION!
  return user
}

// CORRECT: Immutability
function updateUser(user, name) {
  return {
    ...user,
    name
  }
}
```

**File Organization:**

```markdown
MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large components
- Organize by feature/domain, not by type
```

**Error Handling:**

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('Detailed user-friendly message')
}
```

**Input Validation:**

```typescript
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  age: z.number().int().min(0).max(150)
})

const validated = schema.parse(input)
```

### 8. Common Patterns Reference

**API Response Format:**

```typescript
interface ApiResponse<T> {
  success: boolean
  data?: T
  error?: string
  meta?: {
    total: number
    page: number
    limit: number
  }
}
```

**Custom Hooks Pattern:**

```typescript
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedValue(value), delay)
    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}
```

**Repository Pattern:**

```typescript
interface Repository<T> {
  findAll(filters?: Filters): Promise<T[]>
  findById(id: string): Promise<T | null>
  create(data: CreateDto): Promise<T>
  update(id: string, data: UpdateDto): Promise<T>
  delete(id: string): Promise<void>
}
```

## Usage Patterns

### Before Starting Work

1. **Select appropriate context prompt** (Development, Research, Review)
2. **Choose agent based on task**:
   - Complex feature → @planner
   - Architecture → @architect
   - New code → @tdd-guide
   - After writing → @code-reviewer
   - Security concerns → @security-reviewer

### During Work

3. **Follow style guidelines** from coding-style rules
4. **Use testing workflow** for all new code
5. **Apply performance patterns** for model selection and context

### After Work

6. **Manual code review** using checklist
7. **Verify security** using security-reviewer
8. **Commit with proper format** using git-workflow rules

## Workflow Examples

### Example 1: New Feature Development

```bash
# 1. Set development context
echo "[DEVELOPMENT MODE - Write code first, prioritize working]"

# 2. Use planner agent
opencode --agent @planner "Plan user authentication feature"

# 3. Use tdd-guide for implementation
opencode --agent @tdd-guide "Implement auth tests first, then code"

# 4. Code review
opencode --agent @code-reviewer "Review authentication implementation"

# 5. Security review
opencode --agent @security-reviewer "Analyze auth for security vulnerabilities"

# 6. Commit with format
git commit -m "feat: add user authentication with JWT tokens"
```

### Example 2: Bug Investigation

```bash
# 1. Set research context
echo "[RESEARCH MODE - Investigate before fixing]"

# 2. Use build-error-resolver if build fails
opencode --agent @build-error-resolver "Fix TypeScript build errors"

# 3. Code review after fix
opencode --agent @code-reviewer "Review bug fix"

# 4. Commit
git commit -m "fix: resolve authentication token expiry bug"
```

### Example 3: Code Refactoring

```bash
# 1. Use refactor-cleaner
opencode --agent @refactor-cleaner "Remove dead code and simplify"

# 2. Architecture review
opencode --agent @architect "Review refactored architecture"

# 3. Performance check
opencode --agent @code-reviewer "Check for performance issues"
```

## Limitations

What we've **lost** vs Claude Code:
- ❌ Automatic rule enforcement (now manual)
- ❌ Automatic context switching (now manual)
- ❌ Hook-based agent orchestration (now manual)

What we've **retained**:
- ✅ All rules as documentation
- ✅ All context patterns as prompts
- ✅ Agent capabilities (via @mention)
- ✅ Multi-session parallel execution

## Best Practices for OpenCode

1. **Manual context setting** - Copy relevant context prompt at start of session
2. **Explicit agent invocation** - Use @agent syntax intentionally
3. **Parallel workflows** - Run multiple sessions for complex tasks
4. **Review checkpoints** - Manual code review after major changes
5. **Style adherence** - Reference style rules periodically

## Next Steps

- [ ] Create `context-templates/` directory with ready-to-use prompts
- [ ] Update all agent definitions with embedded rules
- [ ] Create workflow scripts for common patterns
- [ ] Document OpenCode-specific best practices

---

**Remember**: OpenCode requires more manual orchestration, but the patterns and quality standards remain the same. Adapt your workflow to be explicit about context and agent selection.
