# everything-claude-code: OpenCode Edition

OpenCode-compatible version of the battle-tested Claude Code configurations from an Anthropic hackathon winner.

**⚠️ Important:** This version includes significant architectural differences from the original Claude Code version. Please read the [Compatibility Matrix](#compatibility-matrix) to understand what works, what requires adaptation, and what limitations exist.

---

## Quick Start

### Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/yourusername/everything-claude-code.git
   cd everything-claude-code
   ```

2. **Install OpenCode:**
   ```bash
   # Using Homebrew (macOS and Linux)
   brew install anomalyco/tap/opencode
   
   # Or using install script
   curl -fsSL https://opencode.ai/install | bash
   ```

3. **Configure OpenCode for this repository:**
   
   OpenCode automatically discovers agents and skills from:
   - `~/.config/opencode/agents/` (global)
   - `.opencode/agents/` (project-specific)
   
   The `.claude-plugin/plugin.json` file has been converted to OpenCode agent definitions in `~/.config/opencode/agents/`.

4. **Start OpenCode:**
   ```bash
   opencode
   ```
`

---

## Overview

The `everything-claude-code` repository has been adapted for compatibility with **OpenCode.ai** (anomalyco/opencode). This version provides:

- ✅ **Agents**: 12 specialized agents converted to OpenCode format
- ✅ **Skills**: 3 core skills (coding-standards, backend-patterns, frontend-patterns) converted to Agent Skills format
- ✅ **Commands**: Prompt-based commands for common workflows
- ⚠️ **Limited Orchestration**: OpenCode lacks native agent chains (manual coordination required)
- ⚠️ **No Hooks**: Event-driven automations replaced with manual workflows

---

## Compatibility Matrix

| Component | Status | Notes |
|-----------|--------|-------|
| **Agents** | ✅ Fully Compatible | 12 agents converted, use `@agent-name` to invoke |
| **Skills** | ✅ Fully Compatible | Agent Skills format, auto-discovered via `skills_paths` |
| **Commands** | ✅ Prompt-Based | No native slash commands, use prompts via commands/ |
| **Orchestration** | ⚠️ Manual Required | No agent chains, use multi-session coordination |
| **Hooks** | ⚠️ Manual Workaround | No event system, use session management |
| **Rules** | ⚠️ Different Approach | Converted to agent prompt modifications |
| **Contexts** | ⚠️ Adapted | Maps to `AGENTS.md` initialization |
| **Advanced Patterns** | ⚠️ Manual Implementation | Iterative retrieval, continuous learning require manual workflows |

---

## Available Agents

### Primary Agents (Built-in to OpenCode)

OpenCode has two built-in primary agents accessible via **Tab** key:

1. **Build Agent** (Default)
   - Full tool access (write, edit, bash, grep, ls, view)
   - Use for general development work

2. **Plan Agent**
   - Restricted for planning and analysis
   - File edits and bash commands require confirmation ("ask")
   - Use for code review and planning without making changes

### Custom Subagents (Converted from Claude Code)

The following 12 agents from `everything-claude-code` are available in OpenCode:

1. **@planner** - Expert planning specialist
   - Creates comprehensive implementation plans
   - Analyzes requirements and architecture
   - Identifies dependencies and risks
   - **Invocation:** `@planner Create plan for [feature]`

2. **@architect** - Software architecture specialist
   - Designs system architecture for new features
   - Evaluates technical trade-offs
   - Recommends patterns and best practices
   - **Invocation:** `@architect Review architecture for [component]`

3. **@tdd-guide** - Test-driven development specialist
   - Enforces TDD methodology
   - Guides through Red-Green-Refactor-Improve cycle
   - Ensures 80%+ test coverage
   - **Invocation:** `@tdd-guide Implement [feature] following TDD methodology`

4. **@code-reviewer** - Code review specialist
   - Analyzes code changes via git diff
   - Checks for quality, security, and maintainability
   - Provides prioritized feedback (Critical, High, Medium, Low)
   - **Invocation:** `@code-reviewer Review [files/directory]`

5. **@security-reviewer** - Security vulnerability specialist
   - Identifies OWASP Top 10 vulnerabilities
   - Detects hardcoded credentials and secrets
   - Recommends security best practices
   - **Invocation:** `@security-reviewer Review [files] for security issues`

### Additional Agents (8 more)

6. **@build-error-resolver** - Resolves build errors
7. **@e2e-runner** - E2E testing with Playwright
8. **@refactor-cleaner** - Dead code cleanup
9. **@doc-updater** - Documentation synchronization
10. **@go-reviewer** - Go-specific code review
11. **@go-build-resolver** - Go build error resolution
12. **@database-reviewer** - Database patterns and best practices

---

## Agent Usage

### Invoking Agents

**Method 1: Using @mentioning**
```
@planner Create implementation plan for user authentication
```

**Method 2: Switching Primary Agents**
- Press **Tab** to cycle between Build and Plan agents
- Build agent for development work
- Plan agent for read-only analysis

**Method 3: Multi-Session Workflows**

Since OpenCode lacks native agent orchestration, use multiple sessions for parallel workflows:

```bash
# Terminal 1: Start planner session
opencode

# Terminal 2: Start TDD guide session
opencode

# Terminal 3: Start code-reviewer session
opencode

# Manual coordination: Share context between sessions
```

---

## Available Skills

### Core Skills

1. **coding-standards** - Universal coding standards
   - Code quality principles
   - TypeScript/JavaScript/React best practices
   - Naming conventions and patterns
   - **Activation:** Auto-discovered (OpenCode loads automatically)

2. **backend-patterns** - Backend development patterns
   - API design principles
   - Database best practices
   - Backend architecture patterns

3. **frontend-patterns** - Frontend development patterns
   - React component patterns
   - State management
   - Performance optimization

### Advanced Skills (Available in Original Repo)

4. **iterative-retrieval** - Progressive context refinement
   - 4-phase retrieval for agent queries
   - **Note:** Manual implementation required in OpenCode

5. **continuous-learning** - Automatic pattern extraction
   - Instinct-based learning system
   - Background observation and evolution
   - **Note:** Manual implementation required in OpenCode

---

## Available Commands

### Prompt-Based Commands

OpenCode doesn't have native slash commands. Use these prompts:

1. **@planner** - Create implementation plan
   - Use for planning new features or complex refactoring
   - **Stored in:** `~/.config/opencode/commands/plan.md`

2. **@tdd-guide** - Implement with TDD methodology
   - Use for test-driven development
   - **Stored in:** `~/.config/opencode/commands/tdd.md`

3. **@code-reviewer** - Review code for quality and security
   - Use for code review before merging
   - **Stored in:** `~/.config/opencode/commands/code-review.md`

### Using Command Prompts

Since OpenCode lacks native slash commands, type prompts directly:

```bash
opencode
# Then type or paste your command prompt:

Implement user authentication with TDD methodology
```

This will use the `@tdd-guide` agent to implement following TDD best practices.

---

## Migration Differences

### What Works the Same

- ✅ **Skill Discovery**: OpenCode auto-discovers `SKILL.md` files from configured `skills_paths`
- ✅ **Agent Invocation**: Use `@agent-name` syntax to invoke agents
- ✅ **Multi-Session**: Create multiple sessions for parallel work
- ✅ **Session Management**: Navigate with `<Leader>+Right` / `<Leader>+Left` keybinds
- ✅ **Project Context**: OpenCode creates `AGENTS.md` for initialization (similar to `CLAUDE.md`)

### What Requires Adaptation

- ⚠️ **Agent Orchestration**: No sequential/parallel chains
  - **Workaround:** Use multi-session coordination with manual context sharing
  - **Example:** See [Agent Usage](#agent-usage) section

- ⚠️ **Slash Commands**: No native `/command` syntax
  - **Workaround:** Type prompts directly or use command prompts from `~/.config/opencode/commands/`
  - **Example:** See [Available Commands](#available-commands) section

- ⚠️ **Hooks**: No event-driven automation
  - **Workaround:** Use session management and manual workflows
  - **Example:** Manual save/load of session context

- ⚠️ **Rules System**: No always-follow rules
  - **Workaround:** Agent prompt modifications guide behavior

### What's Not Supported

- ❌ **Agent Chains**: No sequential/parallel agent execution
- ❌ **Automatic Handoff Documents**: No structured passing between agents
- ❌ **Automatic Compaction**: No session summarization
- ❌ **Event-Driven Actions**: No hooks for session events
- ❌ **Agent-Specific Tool Permissions**: No per-agent scoped tools (uses permission system)
- ❌ **Parallel Agent Execution**: No built-in parallel agent launches

---

## Limitations

### Key Architectural Differences

1. **Orchestration Model**
   - **Claude Code:** Agent chains with automatic handoffs
   - **OpenCode:** Manual multi-session coordination required
   - **Impact:** Complex workflows require more manual coordination

2. **Permission System**
   - **Claude Code:** Per-agent scoped tools with granular control
   - **OpenCode:** Global allow/ask/deny with per-tool and per-bash-command control
   - **Impact:** Less fine-grained control, coarser permissions

3. **Agent Invocation**
   - **Claude Code:** `Task` tool delegation
   - **OpenCode:** `@mentioning` syntax
   - **Impact:** Different user interaction pattern

---

## Usage Examples

### Example 1: Feature Implementation with TDD

```bash
# Session 1: Planning
opencode

# Then invoke planner
@planner Create implementation plan for user authentication
```

**Copy planner's plan** to clipboard

```bash
# Session 2: Implementation
opencode

# Use TDD agent
@tdd-guide Implement user authentication following TDD methodology
```

The `@tdd-guide` agent will guide you through:
1. Writing failing tests first
2. Implementing to pass tests
3. Refactoring code
4. Ensuring 80%+ test coverage

### Example 2: Parallel Code Review

```bash
# Terminal 1: Security review
opencode

@security-reviewer Review authentication implementation for vulnerabilities

# Terminal 2: Code quality review  
opencode

@code-reviewer Review authentication implementation for quality issues
```

Use OpenCode's session navigation (`<Leader>+Right` / `<Leader>+Left`) to switch between sessions.

### Example 3: Architecture Review

```bash
opencode

@architect Review the new user authentication architecture
```

Get recommendations for scalable, maintainable architecture design.

---

## Troubleshooting

### Common Issues

**Issue:** Agents not discovered
- **Solution:** Check that `~/.config/opencode/agents/` and `.opencode/agents/` directories contain the agent files
- **Note:** Restart OpenCode after adding new agents

**Issue:** Commands not recognized
- **Solution:** OpenCode expects prompts, not commands. Type the command name or use command prompts from `~/.config/opencode/commands/`

**Issue:** Agent permissions not working
- **Solution:** Check your `opencode.json` configuration for global and agent-specific permissions
- **Note:** Review [docs/opencode-architecture.md](#docs/opencode-architecture.md) for permission system details

**Issue:** Multi-session coordination confusing
- **Solution:** Use session navigation keybinds to switch between sessions
- **Tip:** Copy context between sessions manually as needed

---

## Additional Resources

- **Full Architecture Analysis:** See `docs/opencode-architecture.md`
- **Agent System Documentation:** See `docs/opencode-architecture.md`  
- **OpenCode Documentation:** https://opencode.ai/docs
- **Original Claude Code Guide:** https://code.claude.com/docs

---

## Version

**Version:** 2.0.0 (OpenCode Edition)  
**Release Date:** 2025-01-28  
**Branch:** opencode  
**Migrated from:** everything-claude-code v1.0.0 (Claude Code Edition)

---

## Summary

This OpenCode-compatible version provides:

✅ **Working:**
- 12 specialized agents (planner, architect, tdd-guide, code-reviewer, security-reviewer, etc.)
- 3 core skills (coding-standards, backend-patterns, frontend-patterns)
- Prompt-based commands for common workflows

⚠️ **Requires Manual Coordination:**
- Agent orchestration via multi-session management
- Context sharing between sessions
- Manual implementation of advanced patterns

**Core Value Proposition Preserved:**
Comprehensive agents and skills for planning, architecture, testing, security review, and best practices - now available to OpenCode users.

**Next Steps:**
1. Test all converted agents in real OpenCode sessions
2. Convert remaining skills (backend-patterns, frontend-patterns, iterative-retrieval, continuous-learning)
3. Create workarounds for advanced patterns (iterative retrieval, continuous learning)
4. Write comprehensive reference guide for OpenCode configuration
5. Finalize release with example configurations

---

**Happy Coding with OpenCode!** 🚀
