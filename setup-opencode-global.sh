#!/bin/bash
# Setup OpenCode Global Configuration on New Machine
# Run this ONCE per machine to enable global agents/skills across all projects

set -e

echo "=========================================="
echo "OpenCode Global Setup Script"
echo "=========================================="
echo ""

# Check if running from everything-claude-code directory
if [[ ! -d "agents" && ! -d "skills" ]]; then
    echo "❌ Error: Must run this script from the everything-claude-code repository root"
    echo ""
    echo "Usage:"
    echo "  cd /path/to/everything-claude-code"
    echo "  bash setup-opencode-global.sh"
    exit 1
fi

# Create global config directory
GLOBAL_DIR="$HOME/.config/opencode"
echo "📁 Creating global config directory: $GLOBAL_DIR"
mkdir -p "$GLOBAL_DIR"

# Copy agents
echo ""
echo "📋 Copying agents..."
if [[ -d "~/.config/opencode/agents" ]]; then
    echo "  Global agents already exist at ~/.config/opencode/agents/"
    read -p "  Overwrite? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        cp -r ~/.config/opencode/agents/* "$GLOBAL_DIR/agents/"
        echo "  ✅ Agents copied (overwritten)"
    else
        echo "  ⏭️  Skipped (keeping existing)"
    fi
else
    mkdir -p "$GLOBAL_DIR/agents"
    cp -r agents/* "$GLOBAL_DIR/agents/"
    echo "  ✅ Agents copied"
fi

# Copy skills
echo ""
echo "📚 Copying skills..."
if [[ -d "~/.config/opencode/skills" ]]; then
    echo "  Global skills already exist at ~/.config/opencode/skills/"
    read -p "  Overwrite? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        rm -rf "$GLOBAL_DIR/skills"/*
        cp -r skills/* "$GLOBAL_DIR/skills/"
        echo "  ✅ Skills copied (overwritten)"
    else
        echo "  ⏭️  Skipped (keeping existing)"
    fi
else
    mkdir -p "$GLOBAL_DIR/skills"
    cp -r skills/* "$GLOBAL_DIR/skills/"
    echo "  ✅ Skills copied"
fi

# Copy context templates
echo ""
echo "📝 Copying context templates..."
if [[ -d "~/.config/opencode/context-templates" ]]; then
    echo "  Global templates already exist at ~/.config/opencode/context-templates/"
    read -p "  Overwrite? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        cp -r ~/.config/opencode/context-templates/* "$GLOBAL_DIR/context-templates/"
        echo "  ✅ Templates copied (overwritten)"
    else
        echo "  ⏭️  Skipped (keeping existing)"
    fi
else
    mkdir -p "$GLOBAL_DIR/context-templates"
    cp -r ~/.config/opencode/context-templates/* "$GLOBAL_DIR/context-templates/"
    echo "  ✅ Templates copied"
fi

# Copy configuration
echo ""
echo "⚙️  Copying configuration..."
if [[ -f "~/.config/opencode/opencode.json" ]]; then
    echo "  Global config already exists at ~/.config/opencode/opencode.json"
    read -p "  Overwrite? [y/N]: " overwrite
    if [[ "$overwrite" =~ ^[Yy]$ ]]; then
        cp ~/.config/opencode/opencode.json "$GLOBAL_DIR/opencode.json"
        echo "  ✅ Config copied (overwritten)"
    else
        echo "  ⏭️  Skipped (keeping existing)"
    fi
else
    cp opencode.json "$GLOBAL_DIR/opencode.json"
    echo "  ✅ Config copied"
fi

# Copy README
if [[ ! -f "$GLOBAL_DIR/README.md" ]]; then
    cp ~/.config/opencode/README.md "$GLOBAL_DIR/README.md"
    echo "  ✅ Global README copied"
fi

# Summary
echo ""
echo "=========================================="
echo "✅ Setup Complete!"
echo "=========================================="
echo ""
echo "Global OpenCode configuration is now available at:"
echo "  $GLOBAL_DIR"
echo ""
echo "What's been configured:"
echo "  ✅ 5 Agents (planner, architect, tdd-guide, code-reviewer, security-reviewer)"
echo "  ✅ 15 Skills (coding-standards, backend-patterns, frontend-patterns, etc.)"
echo "  ✅ 9 Context Templates (development-mode, research-mode, etc.)"
echo "  ✅ 1 Configuration (opencode.json)"
echo ""
echo "🚀 Now you can use OpenCode in ANY project on this machine:"
echo ""
echo "  cd /path/to/any-project"
echo "  opencode"
echo "  @planner Create plan for X"
echo ""
echo "Your agents and skills will work globally!"
echo ""
