# OpenCode Migration Task List

## Overview
Comprehensive task breakdown for adapting **everything-claude-code** repository for compatibility with **OpenCode.ai** (anomalyco/opencode).

**Branch:** `opencode`  
**Total Tasks:** 14  
**Status:** Ready to begin execution

---

## High Priority Tasks (Foundational)

### #1: Research: OpenCode vs Claude Code Architecture
**Priority:** HIGH  
**Status:** 📋 Pending

**Goal:** Deep analysis of OpenCode's agent system vs Claude Code

**Key Deliverables:**
- [ ] Study OpenCode's documentation at https://opencode.ai/docs/agents
- [ ] Understand two agent types (primary agents vs subagents)
- [ ] Document built-in agents (Build, Plan, General, Explore)
- [ ] Map Claude Code's 12 agents to OpenCode equivalents
- [ ] Create detailed compatibility matrix
- [ ] Document what works, needs adaptation, or is impossible

**Output:** `docs/opencode-architecture.md` - Comprehensive architecture comparison

---

### #2: Convert Agent System for OpenCode
**Priority:** HIGH  
**Status:** 📋 Pending  
**Dependencies:** Task #1

**Goal:** Convert all 12 specialized agents to OpenCode format

**Scope:**
Convert these agents in priority order:
1. **planner** - Feature planning
2. **architect** - System design
3. **tdd-guide** - Test-driven development
4. **code-reviewer** - Code quality review
5. **security-reviewer** - Security audit
6. **build-error-resolver** - Fix build errors
7. **e2e-runner** - E2E testing
8. **refactor-cleaner** - Dead code cleanup
9. **doc-updater** - Documentation sync
10. **go-reviewer** - Go-specific review
11. **go-build-resolver** - Go build errors
12. **database-reviewer** - Database patterns

**Conversion Steps per Agent:**
- [ ] Create markdown agent definition (`~/.config/opencode/agents/` or `.opencode/agents/`)
- [ ] Map Claude Code tools to OpenCode's permission system
- [ ] Set mode (subagent for most, primary for Build/Plan)
- [ ] Configure model assignment or inheritance
- [ ] Write agent description and usage guide

**Key OpenCode Differences:**
- No native agent orchestration (manual coordination needed)
- Different permission system (allow/ask/deny vs scoped tools)
- Agent invocation via @mentioning instead of Task tool
- Multi-session support for parallel workflows

---

### #3: Convert Skills to Agent Skills
**Priority:** HIGH  
**Status:** 📋 Pending  
**Dependencies:** Task #2

**Goal:** Convert 14+ skills to OpenCode's Agent Skills format

**Priority Skills:**
1. **coding-standards** - Foundation
2. **backend-patterns** - Backend best practices
3. **frontend-patterns** - Frontend patterns
4. **iterative-retrieval** - Progressive context refinement

**Conversion Process per Skill:**
- [ ] Extract existing skill content from `skills/*/SKILL.md`
- [ ] Create SKILL.md format with frontmatter:
  - `description`
  - `mode` (subagent)
  - `model` (optional)
  - `temperature` (optional)
  - `tools` (write, edit, bash, grep, ls, view)
- [ ] Adapt to OpenCode's permission format
- [ ] Place in `~/.config/opencode/skills/` (global) or `.opencode/skills/` (project)
- [ ] Ensure OpenCode's `skills_paths` configuration includes these paths

**Format Example:**
\`\`\`markdown
---
description: Progressive context retrieval for subagents
mode: subagent
model: anthropic/claude-sonnet-4-20250514
tools:
  write: true
  edit: true
  bash: true
---

[Instructions here...]
\`\`\`

---

### #9: Write Migration Documentation
**Priority:** HIGH  
**Status:** 📋 Pending  
**Dependencies:** All conversion tasks

**Goal:** Create comprehensive user-facing migration guide

**Deliverables:**
- [ ] Comprehensive README with installation instructions
- [ ] Compatibility matrix (table format)
- [ ] Before/after workflow examples
- [ ] Known limitations and trade-offs section
- [ ] Troubleshooting guide
- [ ] Quick start guide

**Structure:**
\`\`\`markdown
# everything-claude-code: OpenCode Edition

## Overview
[What this is and why OpenCode]

## Installation
[Step-by-step setup]

## Compatibility Matrix
| Feature | Status | Notes |
|----------|--------|-------|
| Agents | ✅ Adapted | Manual coordination needed |
| Skills | ✅ Native | Full compatibility |
| Commands | ⚠️ Prompts | No slash commands |
| Orchestration | ❌ Limited | Multi-session workaround |
| Hooks | ❌ Manual | Session-based alternative |

## Usage
[How to use migrated components]

## Limitations
[What's not supported in OpenCode]

## Troubleshooting
[Common issues and solutions]
\`\`\`

---

### #10: Test Converted Agents
**Priority:** HIGH  
**Status:** 📋 Pending  
**Dependencies:** Task #2

**Goal:** Validate all agents work correctly in OpenCode

**Test Checklist:**
- [ ] Agent discovery from configured paths
- [ ] Agent loads with correct configuration
- [ ] Agent invocation via @mentioning works
- [ ] Tool permissions enforced correctly
- [ ] Primary agent switching (Tab key)
- [ ] Session creation and navigation

**Validation:**
Test in real OpenCode session and document any issues or edge cases

---

### #11: Test Skills Discovery
**Priority:** HIGH  
**Status:** 📋 Pending  
**Dependencies:** Task #3

**Goal:** Verify skills work correctly in OpenCode

**Test Checklist:**
- [ ] Skill discovery from `skills_paths` configuration
- [ ] Each skill loads with SKILL.md format
- [ ] Skill activation via agent context
- [ ] Skill metadata validation
- [ ] Tool permissions work as expected

**Validation:**
Test with various skills and document any format issues

---

## Medium Priority Tasks

### #4: Adapt Commands for OpenCode
**Priority:** MEDIUM  
**Status:** 📋 Pending

**Goal:** Adapt 20+ commands for OpenCode compatibility

**Approach:**
Since OpenCode lacks native slash commands:
- Convert to **prompts** stored in `~/.config/opencode/commands/`
- Or create **custom command workflows** via OpenCode's configuration
- Document manual invocation methods

**Key Commands to Adapt:**
- `/plan` → "Use planner agent to create implementation plan"
- `/tdd` → "Use tdd-guide agent for test-driven development"
- `/code-review` → "Use code-reviewer agent"
- `/verify` → "Verify changes with multi-agent check"
- `/orchestrate` → Document: Requires manual multi-session coordination

---

### #5: Convert Rules and Contexts
**Priority:** MEDIUM  
**Status:** 📋 Pending

**Goal:** Adapt rules/ and contexts/ for OpenCode

**Challenge:** OpenCode lacks equivalent system

**Approach:**
- Convert rules to **agent prompt modifications**
- Map contexts to **AGENTS.md** initialization file
- Create **guidance** for rule enforcement
- Implement **workarounds** for missing features

---

### #6: Create Hooks Equivalent System
**Priority:** MEDIUM  
**Status:** 📋 Pending

**Goal:** Create alternative to Claude Code's event-driven hooks

**OpenCode Features to Leverage:**
- Session management for memory persistence
- Multi-session support
- Manual context initialization (AGENTS.md)

**Deliverables:**
- [ ] Document session save/load workflows
- [ ] Create manual compaction prompts
- [ ] Guide for context preservation

---

### #7: Adapt Advanced Patterns
**Priority:** MEDIUM  
**Status:** 📋 Pending

**Goal:** Create manual implementations for advanced patterns

**Patterns to Adapt:**

**Iterative Retrieval:**
- Create manual 4-phase guide (dispatch → evaluate → refine → loop)
- Document when to use for subagent context problems

**Continuous Learning:**
- Document manual observation and pattern extraction workflow
- Create instinct-based learning process

**Parallel Orchestration:**
- Use OpenCode's multi-session capability
- Create coordination documentation for parallel workflows
- Document session cycling navigation (<Leader>+Right, <Leader>+Left)

---

### #12: Test Commands and Workflows
**Priority:** MEDIUM  
**Status:** 📋 Pending  
**Dependencies:** Task #4

**Goal:** Verify commands work in OpenCode environment

**Test Areas:**
- [ ] Each converted command's prompt works
- [ ] Manual invocation methods produce expected results
- [ ] Command outputs are accurate
- [ ] Edge cases handled correctly

**Documentation:**
Document any issues or workarounds needed

---

### #13: Create Compatibility Reference Guide
**Priority:** MEDIUM  
**Status:** 📋 Pending  
**Dependencies:** All tasks

**Goal:** Create comprehensive developer reference

**Content:**
- [ ] OpenCode configuration schema documentation
- [ ] Agent Skills format examples
- [ ] Permission system usage patterns
- [ ] Migration best practices
- [ ] Troubleshooting common issues

**Output:** `docs/OPENCODE_REFERENCE.md`

---

### #14: Prepare Release v2.0.0 (OpenCode Edition)
**Priority:** MEDIUM  
**Status:** 📋 Pending  
**Dependencies:** All tasks

**Goal:** Finalize OpenCode-compatible release

**Deliverables:**
- [ ] Example `opencode.json` configuration file
- [ ] `AGENTS.md` template for project context
- [ ] CHANGELOG documenting migration changes
- [ ] Release notes for version 2.0.0 (OpenCode Edition)
- [ ] Installation/setup guide specific to OpenCode
- [ ] Tag release in git

---

## Low Priority Tasks

### #8: Migrate Scripts and Utilities
**Priority:** LOW  
**Status:** 📋 Pending

**Goal:** Ensure scripts work across OpenCode environment

**Tasks:**
- [ ] Audit all scripts in `/scripts/` directory
- [ ] Identify Claude Code API dependencies
- [ ] Create OpenCode-compatible alternatives
- [ ] Ensure cross-platform compatibility

---

## Next Steps

### Immediate Actions (This Week)
1. ✅ **Start Task #1:** Research OpenCode architecture thoroughly
2. ⏭ **Begin Task #2:** Convert priority agents (planner, architect, tdd-guide, code-reviewer, security-reviewer)
3. ⏭ **Start Task #3:** Convert core skills (coding-standards, backend-patterns, frontend-patterns)

### Execution Strategy
- Work tasks in dependency order (#1 → #2 → #3 → #4)
- Test immediately after each conversion
- Document issues as they arise
- Iterate and refine approach

### Validation Phase
- Complete all conversion tasks
- Run testing tasks (#10, #11, #12)
- Write documentation (#9, #13)
- Prepare release (#14)

---

## Key Differences Summary

| Aspect | Claude Code | OpenCode | Impact |
|--------|-------------|----------|---------|
| **Agent Orchestration** | Native | Limited | Manual coordination needed |
| **Agent Invocation** | Task tool | @mentioning | Different mechanism |
| **Agent Permissions** | Per-agent scoped | Permission system | Mapping required |
| **Multi-Agent** | Parallel chains | Multi-session | Sessions need coordination |
| **Skills** | Custom format | Agent Skills | Format compatible |
| **Slash Commands** | Native | None | Become prompts |
| **Hooks** | Event-driven | None | Manual workflows |
| **Rules** | Always-follow | Agent prompts | Different mechanism |
| **Contexts** | Dynamic injection | AGENTS.md | Adaptation needed |

---

## Success Criteria

Migration is successful when:
- [ ] All 12 agents converted and tested
- [ ] All 14+ skills converted and discoverable
- [ ] Documentation covers compatibility matrix
- [ ] Testing validates all conversions
- [ ] Release package is ready for users
- [ ] Users can install and use with OpenCode

---

**Last Updated:** 2026-01-27  
**Branch:** opencode  
**TaskMaster Config:** `.taskmaster/` directory
