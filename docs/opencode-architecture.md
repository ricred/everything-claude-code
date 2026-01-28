# OpenCode vs Claude Code Architecture Analysis

## Overview

This document analyzes the fundamental architectural differences between **Claude Code** and **OpenCode.ai** (anomalyco/opencode) to inform the migration of `everything-claude-code` repository for OpenCode compatibility.

**Repository:** everything-claude-code  
**Target Platform:** OpenCode.ai (anomalyco/opencode)  
**Last Updated:** 2026-01-27

---

## Agent System Architecture

### Claude Code Agent System

Claude Code features a sophisticated multi-agent orchestration system:

1. **Agent Definition:** Separate `.md` files in `~/.claude/agents/` with frontmatter specifying name, description, tools, and model
2. **Agent Orchestration:** Native support for sequential and parallel agent workflows
   - Sequential chains: `planner → tdd-guide → code-reviewer → security-reviewer`
   - Parallel execution: Multiple agents running simultaneously
   - Split-role subagents for diverse analysis
3. **Context Management:** Each agent gets scoped context and tool permissions
4. **Handoff Documents:** Structured format for passing context between agents
5. **Agent Delegation Rules:** Rules in `rules/agents.md` for when to delegate to which agent
6. **Tool Permissions:** Per-agent scoped tools (e.g., `code-reviewer` has `write: false`)

### OpenCode Agent System

OpenCode takes a fundamentally different approach:

1. **Agent Types:**
   - **Primary Agents:** Main assistants users interact with directly (2 built-in)
   - **Subagents:** Specialized assistants that primary agents can invoke (2 built-in)
   
2. **Built-in Agents:**
   - **Build:** Default agent with all tools enabled for full development work
   - **Plan:** Restricted agent for planning and analysis (file edits and bash set to "ask")
   - **General:** General-purpose subagent for researching complex questions and multi-step tasks
   - **Explore:** Fast, read-only agent for exploring codebases

3. **Agent Configuration:**
   - **JSON:** `opencode.json` or `~/.config/opencode/opencode.json`
   - **Markdown:** `~/.config/opencode/agents/*.md` or `.opencode/agents/*.md`
   - Agent format supports: `mode`, `model`, `prompt`, `temperature`, `maxSteps`, `tools`, `permission`, `hidden`, `taskPermission`

4. **Permission System:**
   - **Three levels:** `allow` (auto-execute), `ask` (prompt), `deny` (disabled)
   - **Per-tool control:** Can set permissions for write, edit, bash, grep, ls, view, webfetch
   - **Per-bash-command control:** Use glob patterns to allow/deny specific commands
   - **Task permissions:** Control which subagents an agent can invoke via glob patterns

5. **Orchestration Approach:**
   - **NO native agent orchestration** (unlike Claude Code)
   - **Multi-session support:** Start multiple agents in parallel on same project
   - **Session navigation:** Parent/child relationships with keybinds (`<Leader>+Right`, `<Leader>+Left`)
   - **Agent invocation:** Subagents invoked via `@mentioning` (e.g., `@general`)

6. **Session Management:**
   - Independent sessions for each agent invocation
   - Manual coordination required for parallel workflows
   - Session cycling for navigation between parent and child sessions

---

## Key Architectural Differences

| Aspect | Claude Code | OpenCode | Migration Impact |
|---------|-------------|----------|----------------|
| **Agent Definition** | Separate `.md` files with frontmatter | JSON or Markdown files | ✅ Format compatible |
| **Agent Orchestration** | Native sequential/parallel chains | Multi-session only | ❌ **Major limitation** |
| **Agent Invocation** | `Task` tool delegation | `@mentioning` | ⚠️ Different mechanism |
| **Tool Permissions** | Per-agent scoped tools | Permission system (allow/ask/deny) | ⚠️ Many-to-one mapping |
| **Agent Workflows** | Automatic chains | Manual coordination | ⚠️ Requires user effort |
| **Multi-Agent** | Built-in parallel execution | Manual multi-session | ⚠️ Sessions need coordination |
| **Slash Commands** | Native (`/plan`, `/tdd`, etc.) | Not native (become prompts) | ⚠️ Lost feature |
| **Hooks System** | Event-driven automations | Not available | ❌ Needs workarounds |
| **Rules System** | Always-follow guidelines | Agent prompt modifications | ⚠️ Different approach |
| **Contexts** | Dynamic system prompt injection | AGENTS.md initialization | ⚠️ Adaptation needed |
| **Memory** | Hooks/session persistence | Multi-session management | ⚠️ Manual implementation |

---

## Claude Code Agent Mapping

### Priority 1: Core Workflow Agents

| Claude Code Agent | OpenCode Equivalent | Configuration |
|------------------|-------------------|-------------|
| **planner** | Custom subagent | `mode: subagent`, `tools: {write: true, edit: true, bash: true}` |
| **architect** | Custom subagent | `mode: subagent`, `tools: {write: true, edit: true, bash: true}` |
| **tdd-guide** | Custom subagent | `mode: subagent`, `tools: {write: true, edit: true, bash: true}` |
| **code-reviewer** | **Explore agent** OR custom subagent | `mode: subagent`, `tools: {write: false, edit: false}` |
| **security-reviewer** | **Explore agent** OR custom subagent | `mode: subagent`, `tools: {write: false, edit: false}` |

**Note:** `code-reviewer` and `security-reviewer` are primarily read-only review agents, so OpenCode's built-in **Explore** agent may be appropriate. However, for consistent access patterns, we'll create custom subagents that allow some tools.

### Priority 2: Specialized Agents

| Claude Code Agent | OpenCode Equivalent | Configuration |
|------------------|-------------------|-------------|
| **build-error-resolver** | Custom subagent | `mode: subagent`, `tools: {bash: true, grep: true}` |
| **e2e-runner** | Custom subagent | `mode: subagent`, `tools: {bash: true, write: true}` |
| **refactor-cleaner** | Custom subagent | `mode: subagent`, `tools: {write: true, edit: true}` |
| **doc-updater** | Custom subagent | `mode: subagent`, `tools: {write: true, edit: true}` |
| **go-reviewer** | Custom subagent | `mode: subagent`, `tools: {write: false, edit: false}` |
| **go-build-resolver** | Custom subagent | `mode: subagent`, `tools: {bash: true, grep: true}` |
| **database-reviewer** | **Explore agent** OR custom subagent | `mode: subagent`, `tools: {write: false, edit: false}` |

---

## Permission System Mapping

### Claude Code Agent-Specific Tools

Claude Code allows granular tool control per agent:

```yaml
# Example: planner agent
tools:
  write: true      # Can create/modify files
  edit: true       # Can edit files
  bash: true       # Can run shell commands
  grep: true       # Can search file contents
  ls: true         # Can list directories
  view: true       # Can view file contents
```

### OpenCode Permission Levels

OpenCode uses a hierarchical permission system:

**Global Permissions (opencode.json):**
```json
{
  "permission": {
    "edit": "allow",      // or "ask" or "deny"
    "bash": "allow"       // or "ask" or "deny"
  }
}
```

**Per-Agent Permissions:**
```json
{
  "agent": {
    "code-reviewer": {
      "permission": {
        "edit": "deny",      // Cannot edit files
        "bash": {
          "git log*": "allow",  // Allow specific commands
          "*": "ask"          // Ask for others
        }
      }
    }
  }
}
```

**Mapping Strategy:**

1. **Write/Edit Agents** → Use `permission.edit = "allow"` or `"ask"`
2. **Read-Only Agents** → Use `permission.edit = "deny"`
3. **Bash-Only Agents** → Use `permission.bash = "allow"` with specific command patterns
4. **Mixed Agents** → Use glob patterns for fine-grained control

---

## Orchestration Workarounds

### Challenge: No Native Agent Chains

OpenCode doesn't support automatic agent orchestration like Claude Code's sequential chains (e.g., `/orchestrate feature "Add authentication"`).

**Workaround: Manual Multi-Session Coordination**

Users must manually coordinate parallel workflows:

1. **Start Multiple Sessions:**
   ```bash
   # Terminal 1: Planner
   opencode -p "Create implementation plan for user auth feature"
   
   # Terminal 2: Implementation
   opencode -p "Implement the plan created in session 1"
   
   # Terminal 3: Review
   opencode -p "Review the implementation from session 2"
   ```

2. **Manual Context Passing:**
   - Copy outputs from session 1
   - Paste as context in session 2
   - Continue until workflow complete

3. **Documentation:**
   Create guides for common workflows showing manual coordination steps.

### Challenge: Agent Invocation Mechanism

Claude Code uses the `Task` tool for agent delegation. OpenCode uses `@mentioning`.

**Workaround: User Awareness**

Document the different invocation patterns:

**Claude Code:**
```
Use Task tool to delegate to code-reviewer agent
```

**OpenCode:**
```
@code-reviewer Please review the authentication implementation
```

This is simpler but requires user to remember the different syntax.

---

## Hooks Replacement Strategy

### Missing Features

OpenCode doesn't have event-driven hooks like Claude Code's system:

1. **Memory Persistence:** Automatically save/load context across sessions
2. **Strategic Compaction:** Suggest session compaction
3. **Session Start/End Hooks:** Run actions on session events

### OpenCode Equivalent Mechanisms

**Session-Based Context Preservation:**

1. **Manual Memory Save:**
   Create prompt: `/save-context`
   Instructions: "Save current session context and decisions to file"

2. **Manual Memory Load:**
   Create prompt: `/load-context [file]`
   Instructions: "Load context from previous session"

3. **Manual Compaction:**
   Create prompt: `/compact-session`
   Instructions: "Summarize current session and start new session"

**AGENTS.md Initialization:**

OpenCode automatically creates `AGENTS.md` for project context when initialized. This is similar to Claude Code's `CLAUDE.md`:

```markdown
# Project Context

## Project Overview
[Brief description]

## Build Commands
```bash
npm run build
npm run test
```

## Tech Stack
- Frontend: TypeScript + React
- Backend: Go + PostgreSQL
```

This provides project-specific context similar to Claude Code's dynamic contexts.

---

## Recommendations for Migration

### High Priority Recommendations

1. **Use Custom Subagents for All 12 Agents**
   - Provides maximum flexibility
   - Allows fine-grained tool control
   - Preserves agent-specific behavior

2. **Create Clear Documentation**
   - Explain architectural differences
   - Provide workaround guides for orchestration
   - Document permission mappings

3. **Maintain Original Claude Code Format**
   - Keep `agents/` directory for reference
   - Document which features require workarounds in OpenCode
   - Helps users understand trade-offs

4. **Prioritize Core Functionality**
   - Convert: planner, architect, tdd-guide, code-reviewer, security-reviewer (first)
   - These are most frequently used and critical for workflows
   - Convert specialized agents as time permits

5. **Use OpenCode's Strengths**
   - Leverage multi-session for parallel workflows
   - Use session navigation keybinds for coordination
   - Document best practices for manual orchestration

### Medium Priority Recommendations

1. **Convert Commands as Prompts**
   - Create easy-to-type prompts
   - Store in accessible location
   - Document usage in README

2. **Create AGENTS.md Templates**
   - Provide template for project initialization
   - Document how to use with OpenCode
   - Include example configurations

3. **Develop Guides for Advanced Patterns**
   - Iterative Retrieval: Manual 4-step process
   - Continuous Learning: Observation and pattern extraction
   - Session Coordination: Multi-session best practices

---

## Critical Limitations to Communicate

### What Cannot Be Replicated

1. **Native Agent Orchestration:**
   - No automatic sequential/parallel agent chains
   - No `/orchestrate` command equivalent
   - Requires manual session coordination

2. **Agent-Specific Tool Permissions:**
   - OpenCode's permission system is coarser (allow/ask/deny)
   - Cannot replicate per-agent scoped tools exactly
   - May lose some fine-grained control

3. **Slash Commands:**
   - No native slash command system
   - Commands become prompts users must type
   - Loses quick invocation convenience

4. **Event-Driven Hooks:**
   - No event-driven automation
   - No automatic memory persistence
   - No session start/end hooks

### What Can Be Adapted

1. ✅ **Agents:** Full compatibility via custom subagents
2. ✅ **Skills:** Native OpenCode Agent Skills format
3. ✅ **Multi-Agent Workflows:** Via manual multi-session coordination
4. ⚠️ **Commands:** Possible as prompts or custom commands
5. ⚠️ **Rules:** Possible as agent prompt modifications
6. ⚠️ **Contexts:** Possible via AGENTS.md initialization
7. ⚠️ **Hooks:** Possible as manual workflows
8. ⚠️ **Advanced Patterns:** Possible with manual implementation

---

## Migration Strategy

### Phase 1: Core Conversion (Week 1-2)

1. **Convert Priority Agents:** planner, architect, tdd-guide, code-reviewer, security-reviewer
2. **Convert Core Skills:** coding-standards, backend-patterns, frontend-patterns
3. **Write Migration Documentation:** User-facing guide
4. **Create OpenCode Configuration Examples:** opencode.json samples

### Phase 2: Extended Conversion (Week 3-4)

1. **Convert Remaining Agents:** 8 specialized agents
2. **Convert Extended Skills:** iterative-retrieval, continuous-learning
3. **Create Advanced Pattern Guides:** Manual implementation documentation
4. **Develop Workaround Guides:** Orchestration, memory, compaction

### Phase 3: Testing and Validation (Week 5)

1. **Test All Agents:** Verify discovery, invocation, permissions
2. **Test All Skills:** Verify discovery, activation, metadata
3. **Test Commands:** Verify prompts work as expected
4. **Document Issues:** Edge cases and workarounds

### Phase 4: Release (Week 6)

1. **Finalize Documentation:** Reference guide, troubleshooting
2. **Prepare Release:** Example configs, CHANGELOG, tags
3. **Validate:** End-to-end workflow testing
4. **Publish:** Release v2.0.0 (OpenCode Edition)

---

## Success Criteria

Migration is successful when:

- [ ] All 12 agents converted and tested in OpenCode
- [ ] All 14+ skills converted and discoverable
- [ ] Migration documentation covers all features and limitations
- [ ] Testing validates all conversions
- [ ] Example configurations provided
- [ ] Known issues and workarounds documented
- [ ] Users can install and use with OpenCode
- [ ] Release v2.0.0 (OpenCode Edition) published

---

## Related Documentation

- **OpenCode Agents Documentation:** https://opencode.ai/docs/agents
- **OpenCode Configuration Reference:** https://opencode.ai/docs/config
- **OpenCode Tools Documentation:** https://opencode.ai/docs/tools
- **Claude Code Documentation:** https://code.claude.com/docs

---

**Document Version:** 1.0  
**Last Updated:** 2026-01-27  
**Author:** TaskMaster Migration Project  
**Status:** Research Phase Complete
