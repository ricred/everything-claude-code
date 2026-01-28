# OpenCode Project Initialization

**Project:** Everything Claude Code (OpenCode Edition)
**Version:** 2.0.0
**Last Updated:** 2025-01-28

---

## Available Agents

All agents are located in `~/.config/opencode/agents/` and can be invoked using `@agent-name` syntax.

### Analysis Agents (Read-Only)

| Agent | Purpose | When to Use | Tools |
|--------|---------|-------------|-------|
| **@planner** | Implementation planning | Complex features, refactoring, architecture changes | read, grep, glob, view |
| **@architect** | System design | Architectural decisions, system design, technical planning | read, grep, glob, view |
| **@code-reviewer** | Code quality review | After writing code, PR reviews, code assessments | read, grep, glob, view |
| **@security-reviewer** | Security analysis | Before commits, security reviews, sensitive features | read, grep, glob, view |

### Implementation Agents (Write-Enabled)

| Agent | Purpose | When to Use | Tools |
|--------|---------|-------------|-------|
| **@tdd-guide** | Test-driven development | New features, bug fixes, refactoring | read, grep, glob, view, write, edit, bash |

---

## Available Skills

All skills are located in `~/.config/opencode/skills/` and automatically discovered by OpenCode.

### General Patterns

- **coding-standards** - Universal coding best practices for TypeScript, JavaScript, React, Node.js
- **backend-patterns** - Backend architecture, API design, database optimization
- **frontend-patterns** - Frontend development patterns for React, Next.js, state management
- **tdd-workflow** - Test-driven development methodology and Red-Green-Refactor cycle

### Advanced Patterns

- **iterative-retrieval** - Progressive context refinement for complex tasks
- **continuous-learning** - Manual daily reflection for pattern extraction
- **continuous-learning-v2** - Instinct-based learning system (advanced)

### Security & Testing

- **security-review** - Security best practices, checklist, and patterns
- **verification-loop** - Comprehensive verification workflow for code changes
- **postgres-patterns** - PostgreSQL patterns, query optimization, schema design

### Language-Specific

- **golang-patterns** - Idiomatic Go patterns, concurrency, error handling
- **golang-testing** - Go testing patterns, TDD, benchmarks, fuzzing
- **clickhouse-io** - ClickHouse analytics patterns, query optimization, data engineering

### Workflow

- **strategic-compact** - Manual context compaction at logical intervals
- **eval-harness** - Formal evaluation framework for eval-driven development
- **project-guidelines-example** - Example project-specific skill template

---

## Context Templates

Copy these templates into OpenCode sessions to establish context and workflow:

### Development Mode

```bash
cat ~/.config/opencode/context-templates/development-mode.txt
```

**Use when:** Writing code, implementing features, fixing bugs

**Behavior:**
- Write code first, explain after
- Prefer working solutions over perfect solutions
- Run tests after changes
- Keep commits atomic

### Research Mode

```bash
cat ~/.config/opencode/context-templates/research-mode.txt
```

**Use when:** Exploring codebase, understanding architecture, investigating bugs

**Behavior:**
- Read widely before concluding
- Ask clarifying questions
- Document findings as you go
- Don't write code until understanding is clear

### Code Review Mode

```bash
cat ~/.config/opencode/context-templates/code-review-mode.txt
```

**Use when:** Reviewing PRs, analyzing code, checking quality

**Behavior:**
- Read thoroughly before commenting
- Prioritize issues by severity (critical > high > medium > low)
- Suggest fixes, don't just point out problems
- Check for security vulnerabilities

### Model Selection

```bash
cat ~/.config/opencode/context-templates/model-selection.txt
```

**Use when:** Choosing which model to use for a task

**Guidelines:**
- Haiku 4.5 - Lightweight, frequent invocation
- Sonnet 4.5 - Main development work
- Opus 4.5 - Complex reasoning, architecture

### TDD Workflow

```bash
cat ~/.config/opencode/context-templates/tdd-workflow.txt
```

**Use when:** Writing new code (MANDATORY for all new features)

**Enforces:**
- Write test first (RED)
- Implement to pass (GREEN)
- Refactor (IMPROVE)
- Verify 80%+ coverage

### Git Workflow

```bash
cat ~/.config/opencode/context-templates/git-workflow.txt
```

**Use when:** Preparing to commit code or create PR

**Provides:**
- Commit message format (conventional commits)
- Feature implementation workflow
- Code quality checklist
- PR review guidelines

---

## Helper Scripts

Located in `.opencode/scripts/`:

### Continuous Learning

- **daily-reflection.sh** - Creates daily reflection template for pattern extraction

### Session Management

- **save-session.sh** - Generates session summary template for memory persistence
- **reset-context.sh** - Prompts for compaction type and shows template
- **load-memory.sh** - Lists and loads previous session memories

### Workflow

- **iterative-retrieval.sh** - Guides through manual iterative retrieval process

**Usage:**
```bash
# Make scripts executable (one-time)
chmod +x .opencode/scripts/*.sh

# Run scripts
.opencode/scripts/daily-reflection.sh
.opencode/scripts/reset-context.sh
```

---

## Project Standards

### Code Quality

- **Immutability:** Always create new objects, never mutate
- **File Organization:** Many small files (200-400 lines), not few large ones
- **Error Handling:** Comprehensive error handling with try/catch
- **Input Validation:** All user inputs validated with schemas (zod)
- **No console.log:** Production code should not have console.log statements

### Testing

- **TDD Required:** Write tests FIRST, then implement
- **Coverage Target:** 80%+ minimum (100% for critical paths, 90%+ for public APIs)
- **Test Types:** Unit tests + Integration tests + E2E tests (all required)
- **TDD Workflow:** RED → GREEN → REFACTOR → VERIFY

### Git Workflow

- **Commit Format:** `<type>: <description>` (feat, fix, refactor, docs, test, chore, perf, ci)
- **Feature Workflow:**
  1. Plan with @planner
  2. Implement with @tdd-guide (write tests first)
  3. Review with @code-reviewer
  4. Security check with @security-reviewer
  5. Commit with conventional format

### Security

- **No Hardcoded Secrets:** All secrets in environment variables
- **Input Validation:** All user inputs validated
- **SQL Injection:** Parameterized queries only
- **XSS Prevention:** Sanitized HTML, CSP headers
- **CSRF Protection:** SameSite cookies, CSRF tokens
- **Authentication/Authorization:** Verified before sensitive operations
- **Rate Limiting:** Enabled on all endpoints
- **Error Messages:** Don't leak sensitive information

---

## Advanced Patterns

### Iterative Retrieval

For complex tasks requiring deep context understanding:

1. **CYCLE 1:** Broad search with initial keywords
2. **CYCLE 2:** Refined search based on findings
3. **CYCLE 3:** Targeted search for specific gaps

**Stopping Criteria:**
- 3+ files with relevance ≥ 0.7
- No critical gaps identified
- Maximum 3 cycles reached

**Script:** `.opencode/scripts/iterative-retrieval.sh`

### Continuous Learning

Manual pattern extraction without automatic hooks:

1. **Daily Reflection:** End of each workday, review sessions
2. **Pattern Identification:** Identify effective patterns and what didn't work
3. **Skill Extraction:** Save reusable patterns to `~/.config/opencode/skills/learned/`
4. **Confidence Scoring:** Update pattern confidence over time (0.3-0.9)

**Script:** `.opencode/scripts/daily-reflection.sh`

### Agent Orchestration

Manual multi-session coordination for complex problems:

1. **Planning:** Use @planner to break into sub-tasks
2. **Parallel Execution:** Run multiple OpenCode sessions simultaneously
   - Session 1: @security-reviewer
   - Session 2: @architect
   - Session 3: @code-reviewer
3. **Synthesis:** Combine results manually into unified plan

---

## Current Focus

**Migration Status:** ✅ COMPLETE

### Completed

- ✅ Research & Architecture analysis
- ✅ Agent system conversion (5 priority agents)
- ✅ Skills library conversion (15 skills)
- ✅ Commands adaptation (3 commands)
- ✅ Rules & Contexts migration (manual workflows)
- ✅ Hooks alternative system (manual orchestration)
- ✅ Advanced patterns adaptation (manual implementation)
- ✅ Scripts migration (5 helper scripts)
- ✅ Testing & validation
- ✅ Compatibility reference guide

### Remaining (Lower Priority)

- 7 additional agents (build-error-resolver, e2e-runner, refactor-cleaner, doc-updater, go-reviewer, go-build-resolver, database-reviewer)

---

## Next Steps

### Immediate

1. **Use converted agents** - Test @planner, @architect, @tdd-guide in real work
2. **Apply context templates** - Copy templates at session start
3. **Test skill discovery** - Verify skills are discoverable in OpenCode
4. **Use helper scripts** - Integrate daily reflection into workflow

### Future

1. **Convert remaining 7 agents** - Lower priority but useful
2. **Create automation scripts** - Reduce manual effort
3. **Share learned skills** - Extract and share patterns from daily reflections
4. **Provide feedback** - Report issues to OpenCode project

---

## Documentation

### User Guides

- [Migration Guide](docs/MIGRATION_PLAN.md) - Complete migration instructions
- [Architecture Research](docs/opencode-architecture.md) - System architecture comparison
- [Compatibility Reference](docs/OPENCODE_REFERENCE.md) - Developer-focused reference
- [Testing Report](docs/opencode-testing-report.md) - Test results and validation

### Technical Docs

- [Rules Migration](docs/opencode-rules-contexts-migration.md) - Rules/contexts manual implementation
- [Hooks Alternatives](docs/opencode-hooks-alternatives.md) - Hooks system replacement
- [Advanced Patterns](docs/opencode-advanced-patterns.md) - Patterns manual implementation
- [Scripts Migration](docs/opencode-scripts-migration.md) - Scripts adaptation

### Configuration

- **Agents:** `~/.config/opencode/agents/` - Agent definitions
- **Skills:** `~/.config/opencode/skills/` - Skills library
- **Templates:** `~/.config/opencode/context-templates/` - Context templates
- **Scripts:** `.opencode/scripts/` - Helper scripts
- **Config:** `opencode.json` - Global configuration

---

## Support

### Getting Help

- **OpenCode Documentation:** https://opencode.ai/docs/
- **GitHub Issues:** https://github.com/anomalyco/opencode/issues
- **Community:** https://discord.gg/opencode

### Reporting Issues

When reporting issues, include:
1. OpenCode version
2. Operating system
3. Agent/skill being used
4. Error message or unexpected behavior
5. Steps to reproduce

---

**Version:** 2.0.0 (OpenCode Edition)
**Release Date:** 2025-01-28
**Status:** Production Ready ✅
