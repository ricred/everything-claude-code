# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-28

### Added

#### OpenCode Migration

- Complete migration from Claude Code to OpenCode.ai compatibility
- New architecture: Agent-based instead of hooks-based
- New format: Markdown with YAML frontmatter for agents/skills
- New workflow: Manual orchestration instead of automatic

#### Agents (5 Converted)

- **@planner** - Implementation planning specialist (read-only)
- **@architect** - System design specialist (read-only)
- **@tdd-guide** - Test-driven development specialist (write-enabled)
- **@code-reviewer** - Code quality review specialist (read-only)
- **@security-reviewer** - Security analysis specialist (read-only)

#### Skills (15 Converted)

**General Patterns:**
- coding-standards - Universal coding best practices
- backend-patterns - Backend architecture and API design
- frontend-patterns - Frontend patterns for React/Next.js
- tdd-workflow - TDD methodology and Red-Green-Refactor cycle

**Advanced Patterns:**
- iterative-retrieval - Progressive context refinement
- continuous-learning - Manual daily reflection system
- continuous-learning-v2 - Instinct-based learning

**Security & Testing:**
- security-review - Security best practices and checklist
- verification-loop - Comprehensive verification workflow
- postgres-patterns - PostgreSQL patterns and optimization

**Language-Specific:**
- golang-patterns - Idiomatic Go patterns
- golang-testing - Go testing, benchmarks, fuzzing
- clickhouse-io - ClickHouse analytics patterns

**Workflow:**
- strategic-compact - Manual context compaction
- eval-harness - Formal evaluation framework
- project-guidelines-example - Project-specific skill template

#### Context Templates (9 Created)

**Workflow Modes:**
- development-mode.txt - Code implementation behavior
- research-mode.txt - Exploration and investigation behavior
- code-review-mode.txt - PR review and analysis behavior

**Guidance:**
- model-selection.txt - Model selection guidelines (Haiku/Sonnet/Opus)
- tdd-workflow.txt - TDD methodology
- git-workflow.txt - Git commit and PR workflow

**Compaction:**
- compact-exploration.txt - After exploration phase
- compact-milestone.txt - After completing milestone
- compact-switch.txt - Before context switch

#### Helper Scripts (5 Created)

- **daily-reflection.sh** - Daily reflection template for continuous learning
- **save-session.sh** - Session summary generator for memory persistence
- **reset-context.sh** - Context reset helper with template prompts
- **load-memory.sh** - Memory listing and loading helper
- **iterative-retrieval.sh** - Iterative retrieval workflow guide

#### Documentation (5 Documents)

- **opencode-architecture.md** - Complete architecture research and comparison
- **MIGRATION_PLAN.md** - Comprehensive migration guide
- **opencode-rules-contexts-migration.md** - Rules/contexts manual implementation
- **opencode-hooks-alternatives.md** - Hooks system replacement guide
- **opencode-advanced-patterns.md** - Advanced patterns manual implementation
- **opencode-scripts-migration.md** - Scripts adaptation guide
- **opencode-testing-report.md** - Comprehensive testing report
- **OPENCODE_REFERENCE.md** - Developer-focused reference guide

#### Configuration Files

- **opencode.json** - Example configuration with agent permissions
- **AGENTS.md** - Project initialization template

### Changed

#### Architecture

- **From:** Claude Code hooks-based automation
- **To:** OpenCode agent-based manual orchestration

#### Workflow

- **From:** Automatic compaction, learning, orchestration
- **To:** Manual context templates, daily reflection, parallel sessions

#### Agent Format

- **From:** JSON agent definitions
- **To:** Markdown with YAML frontmatter

### Deprecated

#### Claude Code-Specific Features

- ❌ Automatic hooks (PreToolUse, PostToolUse, Stop)
- ❌ Automatic compaction triggers
- ❌ Automatic pattern extraction (continuous-learning skill)
- ❌ CLAUDE_SESSION_ID environment variable
- ❌ Hook-based agent orchestration

### Removed

#### Deprecated Scripts

- All hook-dependent scripts (requires manual replacement)

### Security

#### Permissions Model

- New: Three-level permission system (allow/ask/deny)
- New: Agent-specific tool permission overrides
- New: Global default with per-agent customizations

### Testing

#### Validation

- ✅ Agent format validation (all 5 agents tested)
- ✅ Skill format validation (all 15 skills tested)
- ✅ Template content validation (all 9 templates tested)
- ✅ Script execution validation (all 5 scripts tested)
- ✅ Cross-platform compatibility (Linux/macOS tested)
- ✅ Documentation completeness (all 5 docs tested)

### Known Limitations

#### Manual Orchestration Required

- No automatic context compaction (use templates)
- No automatic pattern learning (use daily reflection)
- No automatic agent coordination (use parallel sessions)
- No session tracking (use session summaries)

#### Lower Priority Agents Not Converted

- 7 agents remain (build-error-resolver, e2e-runner, refactor-cleaner, doc-updater, go-reviewer, go-build-resolver, database-reviewer)
- These can be converted following the same patterns as the 5 priority agents

### Migration Guide

See [MIGRATION_PLAN.md](docs/MIGRATION_PLAN.md) for complete migration instructions including:

- Installation and setup
- Compatibility matrix (what works, needs adaptation, impossible)
- Usage examples
- Troubleshooting guide
- Before/after workflow comparisons

### Compatibility

| Feature | Claude Code | OpenCode | Migration Status |
|---------|-------------|-----------|-----------------|
| Agents | ✅ Native | ✅ Native (different format) | ✅ Converted |
| Skills | ✅ Native | ✅ Native (SKILL.md) | ✅ Converted |
| Hooks | ✅ Native | ❌ Not Supported | 🔄 Manual Alternatives |
| Rules | ✅ Native | ❌ Not Supported | 🔄 Manual Enforcement |
| Contexts | ✅ Native | ❌ Not Supported | 🔄 Manual Templates |
| Commands | ✅ Native | ⚠️ Limited | ✅ Adapted |
| Continuous Learning | ✅ Native | ❌ Not Supported | 🔄 Manual Reflection |

### Upgrade Instructions

#### For Existing Users

1. Backup current configuration:
   ```bash
   cp -r ~/.claude ~/.claude.backup
   ```

2. Install OpenCode:
   ```bash
   npm install -g @opencode/cli
   ```

3. Copy converted assets:
   ```bash
   mkdir -p ~/.config/opencode/{agents,skills,context-templates}
   cp -r ~/.config/opencode/agents ~/.config/opencode/
   cp -r ~/.config/opencode/skills ~/.config/opencode/
   cp -r ~/.config/opencode/context-templates ~/.config/opencode/
   ```

4. Initialize project:
   ```bash
   cp AGENTS.md .opencode/AGENTS.md
   cp opencode.json .opencode/opencode.json
   ```

5. Start using OpenCode:
   ```bash
   opencode
   ```

#### For New Users

1. Clone repository:
   ```bash
   git clone https://github.com/your-repo/everything-claude-code
   cd everything-claude-code
   ```

2. Switch to opencode branch:
   ```bash
   git checkout opencode
   ```

3. Copy configuration to OpenCode:
   ```bash
   mkdir -p ~/.config/opencode/{agents,skills,context-templates}
   cp -r ~/.config/opencode/* ~/.config/opencode/
   ```

4. Start using OpenCode:
   ```bash
   opencode
   ```

### Breaking Changes

#### Agent Invocation

- **Before:** Commands used (e.g., `/plan`, `/tdd`)
- **After:** Agent mention syntax (`@planner`, `@tdd-guide`)

#### Context Management

- **Before:** Automatic compaction and context loading
- **After:** Manual template copying and session summaries

#### Workflow Orchestration

- **Before:** Automatic multi-agent coordination
- **After:** Manual parallel sessions with synthesis

### Credits

- Original everything-claude-code repository architecture and patterns
- OpenCode.ai platform and documentation
- Community feedback and testing

### Links

- [OpenCode Documentation](https://opencode.ai/docs/)
- [OpenCode GitHub](https://github.com/anomalyco/opencode)
- [Migration Guide](docs/MIGRATION_PLAN.md)
- [Testing Report](docs/opencode-testing-report.md)
- [Compatibility Reference](docs/OPENCODE_REFERENCE.md)
