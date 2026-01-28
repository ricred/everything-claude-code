# Setup OpenCode Global Configuration on Windows
# Run this ONCE per machine to enable global agents/skills across all projects

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "OpenCode Global Setup Script (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running from everything-claude-code directory
if (-not (Test-Path "agents") -and -not (Test-Path "skills")) {
    Write-Host "❌ Error: Must run this script from the everything-claude-code repository root" -ForegroundColor Red
    Write-Host ""
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  cd C:\path\to\everything-claude-code"
    Write-Host "  .\setup-opencode-global.ps1"
    exit 1
}

# Create global config directory
$globalDir = Join-Path $env:USERPROFILE ".config\opencode"
Write-Host "📁 Creating global config directory: $globalDir" -ForegroundColor Green
New-Item -ItemType Directory -Force -Path $globalDir | Out-Null

# Copy agents
Write-Host ""
Write-Host "📋 Copying agents..." -ForegroundColor Cyan
if (Test-Path "$globalDir\agents") {
    Write-Host "  Global agents already exist at $globalDir\agents" -ForegroundColor Yellow
    $overwrite = Read-Host "  Overwrite? [Y/N]: "
    if ($overwrite -match '^[Yy]$') {
        Copy-Item -Recurse -Force -Path ".\.config\opencode\agents\*" -Destination "$globalDir\agents\"
        Write-Host "  ✅ Agents copied (overwritten)" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Skipped (keeping existing)" -ForegroundColor Yellow
    }
} else {
    New-Item -ItemType Directory -Force -Path "$globalDir\agents" | Out-Null
    Copy-Item -Recurse -Force -Path ".\.config\opencode\agents\*" -Destination "$globalDir\agents\"
    Write-Host "  ✅ Agents copied" -ForegroundColor Green
}

# Copy skills
Write-Host ""
Write-Host "📚 Copying skills..." -ForegroundColor Cyan
if (Test-Path "$globalDir\skills") {
    Write-Host "  Global skills already exist at $globalDir\skills" -ForegroundColor Yellow
    $overwrite = Read-Host "  Overwrite? [Y/N]: "
    if ($overwrite -match '^[Yy]$') {
        Remove-Item -Recurse -Force -Path "$globalDir\skills\*" -ErrorAction SilentlyContinue
        Copy-Item -Recurse -Force -Path "skills\*" -Destination "$globalDir\skills\"
        Write-Host "  ✅ Skills copied (overwritten)" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Skipped (keeping existing)" -ForegroundColor Yellow
    }
} else {
    New-Item -ItemType Directory -Force -Path "$globalDir\skills" | Out-Null
    Copy-Item -Recurse -Force -Path "skills\*" -Destination "$globalDir\skills\"
    Write-Host "  ✅ Skills copied" -ForegroundColor Green
}

# Copy context templates
Write-Host ""
Write-Host "📝 Copying context templates..." -ForegroundColor Cyan
if (Test-Path "$globalDir\context-templates") {
    Write-Host "  Global templates already exist at $globalDir\context-templates" -ForegroundColor Yellow
    $overwrite = Read-Host "  Overwrite? [Y/N]: "
    if ($overwrite -match '^[Yy]$') {
        Copy-Item -Recurse -Force -Path ".\.config\opencode\context-templates\*" -Destination "$globalDir\context-templates\"
        Write-Host "  ✅ Templates copied (overwritten)" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Skipped (keeping existing)" -ForegroundColor Yellow
    }
} else {
    New-Item -ItemType Directory -Force -Path "$globalDir\context-templates" | Out-Null
    Copy-Item -Recurse -Force -Path ".\.config\opencode\context-templates\*" -Destination "$globalDir\context-templates\"
    Write-Host "  ✅ Templates copied" -ForegroundColor Green
}

# Copy configuration
Write-Host ""
Write-Host "⚙️  Copying configuration..." -ForegroundColor Cyan
if (Test-Path "$globalDir\opencode.json") {
    Write-Host "  Global config already exists at $globalDir\opencode.json" -ForegroundColor Yellow
    $overwrite = Read-Host "  Overwrite? [Y/N]: "
    if ($overwrite -match '^[Yy]$') {
        Copy-Item -Force -Path "opencode.json" -Destination "$globalDir\opencode.json"
        Write-Host "  ✅ Config copied (overwritten)" -ForegroundColor Green
    } else {
        Write-Host "  ⏭️  Skipped (keeping existing)" -ForegroundColor Yellow
    }
} else {
    Copy-Item -Force -Path "opencode.json" -Destination "$globalDir\opencode.json"
    Write-Host "  ✅ Config copied" -ForegroundColor Green
}

# Copy README if exists
if (Test-Path ".\.config\opencode\README.md") {
    Copy-Item -Force -Path ".\.config\opencode\README.md" -Destination "$globalDir\README.md"
    Write-Host "  ✅ Global README copied" -ForegroundColor Green
}

# Summary
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Global OpenCode configuration is now available at:" -ForegroundColor Cyan
Write-Host "  $globalDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "What's been configured:" -ForegroundColor Cyan
Write-Host "  ✅ 5 Agents (planner, architect, tdd-guide, code-reviewer, security-reviewer)" -ForegroundColor Green
Write-Host "  ✅ 15 Skills (coding-standards, backend-patterns, frontend-patterns, etc.)" -ForegroundColor Green
Write-Host "  ✅ 9 Context Templates (development-mode, research-mode, etc.)" -ForegroundColor Green
Write-Host "  ✅ 1 Configuration (opencode.json)" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Now you can use OpenCode in ANY project on this machine:" -ForegroundColor Green
Write-Host ""
Write-Host "  cd C:\path\to\any-project" -ForegroundColor Yellow
Write-Host "  opencode" -ForegroundColor Yellow
Write-Host "  @planner Create plan for X" -ForegroundColor Yellow
Write-Host ""
Write-Host "Your agents and skills will work globally!" -ForegroundColor Green
Write-Host ""
