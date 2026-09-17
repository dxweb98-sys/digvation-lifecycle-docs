# DIGVATION_CLAUDE_BOOTSTRAP
[CmdletBinding()]
param(
    [string]$LifecycleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)),
    [switch]$Deep
)

$ErrorActionPreference = "Continue"
$ok = 0
$warn = 0
$fail = 0

function Pass([string]$Message) { $script:ok++; Write-Host "[PASS] $Message" -ForegroundColor Green }
function Warn([string]$Message) { $script:warn++; Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Fail([string]$Message) { $script:fail++; Write-Host "[FAIL] $Message" -ForegroundColor Red }

try { $LifecycleRoot = (Resolve-Path -LiteralPath $LifecycleRoot).Path }
catch { Fail "Lifecycle root not found: $LifecycleRoot"; exit 1 }

Write-Host "Digvation Claude Code verification" -ForegroundColor Cyan
Write-Host "Root: $LifecycleRoot"
Write-Host ""

if (Test-Path (Join-Path $LifecycleRoot "AGENTS.md")) { Pass "Root AGENTS.md exists" } else { Fail "Root AGENTS.md missing" }
if (Test-Path (Join-Path $LifecycleRoot "CLAUDE.md")) { Pass "Root CLAUDE.md exists" } else { Fail "Root CLAUDE.md missing" }
if (Test-Path (Join-Path $LifecycleRoot "business")) { Pass "Current business/ boundary exists" }
elseif (Test-Path (Join-Path $LifecycleRoot "pos")) { Fail "Historical pos/ boundary detected without business/. Refresh the lifecycle overlay before relying on this setup." }
else { Warn "business/ boundary not found; verify workspace layout" }

$expectedSkills = @(
    "digvation-router", "digvation-feature", "digvation-ui",
    "digvation-debug", "digvation-security", "digvation-release"
)
foreach ($skill in $expectedSkills) {
    $path = Join-Path $LifecycleRoot ".claude\skills\$skill\SKILL.md"
    if (Test-Path $path) { Pass "Skill present: $skill" } else { Fail "Skill missing: $skill" }
}

$claude = Get-Command claude -ErrorAction SilentlyContinue
if ($claude) {
    Pass "Claude Code CLI found: $($claude.Source)"
    try {
        $version = (& claude --version 2>&1 | Out-String).Trim()
        if ($version) { Write-Host "       $version" -ForegroundColor DarkGray }
    } catch {}
} else {
    Fail "Claude Code CLI not found"
}

$plugins = @(
    "superpowers@claude-plugins-official",
    "context7@claude-plugins-official",
    "playwright@claude-plugins-official",
    "github@claude-plugins-official",
    "code-review@claude-plugins-official",
    "skill-creator@claude-plugins-official",
    "ui-ux-pro-max@ui-ux-pro-max-skill"
)

if ($claude) {
    try {
        $pluginList = (& claude plugin list 2>&1 | Out-String)
        foreach ($plugin in $plugins) {
            $short = ($plugin -split "@")[0]
            if ($pluginList -match [regex]::Escape($short)) { Pass "Plugin visible: $plugin" }
            else { Warn "Plugin not confirmed by 'claude plugin list': $plugin" }
        }
    } catch {
        Warn "Could not query Claude plugin list: $($_.Exception.Message)"
    }

    try {
        $mcpList = (& claude mcp list 2>&1 | Out-String)
        if ($mcpList -match "codebase-memory") { Pass "Codebase Memory MCP visible to Claude" }
        else { Warn "Codebase Memory MCP not confirmed by 'claude mcp list'" }
        if ($mcpList -match "context7") { Pass "Context7 MCP visible to Claude" }
        else { Warn "Context7 MCP may be plugin-managed; verify with /mcp inside Claude" }
        if ($mcpList -match "playwright") { Pass "Playwright MCP visible to Claude" }
        else { Warn "Playwright MCP may be plugin-managed; verify with /mcp inside Claude" }
        if ($mcpList -match "github") { Pass "GitHub MCP visible to Claude" }
        else { Warn "GitHub MCP may be plugin-managed; verify with /mcp inside Claude" }
    } catch {
        Warn "Could not query Claude MCP list: $($_.Exception.Message)"
    }
}

$cbm = Get-Command codebase-memory-mcp -ErrorAction SilentlyContinue
if (-not $cbm) {
    $candidate = Join-Path $env:LOCALAPPDATA "Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
    if (Test-Path $candidate) { $cbm = Get-Item $candidate }
}
if ($cbm) {
    $cbmPath = if ($cbm.PSObject.Properties.Name -contains "Source" -and $cbm.Source) {
        $cbm.Source
    } elseif ($cbm.PSObject.Properties.Name -contains "FullName" -and $cbm.FullName) {
        $cbm.FullName
    } else {
        $cbm.ToString()
    }
    Pass "Codebase Memory executable found: $cbmPath"
    try {
        $projects = (& $cbmPath cli list_projects 2>&1 | Out-String)
        if ($projects.Trim()) {
            Pass "Codebase Memory project registry is readable"
            if ($Deep) { Write-Host $projects }
        }
    } catch {
        Warn "Codebase Memory is installed but list_projects failed"
    }
} else {
    Warn "Codebase Memory executable not found"
}

$gh = Get-Command gh -ErrorAction SilentlyContinue
if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
    Pass "GitHub MCP token is available in current environment"
} elseif ($gh) {
    & gh auth status 1>$null 2>$null
    if ($LASTEXITCODE -eq 0) { Pass "gh is authenticated; start-claude.ps1 can inject a process-only GitHub MCP token" }
    else { Warn "gh is installed but not authenticated; run 'gh auth login' before using GitHub MCP" }
} else {
    Warn "No GitHub MCP credential source found. Install/authenticate gh or provide GITHUB_PERSONAL_ACCESS_TOKEN."
}

Write-Host ""
Write-Host "Summary: $ok passed, $warn warnings, $fail failed" -ForegroundColor Cyan
if ($fail -gt 0) { exit 1 }
exit 0

