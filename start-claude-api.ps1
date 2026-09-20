# DIGVATION_CLAUDE_API_BOOTSTRAP

# Preserve every argument exactly as supplied after this script name.
# This avoids PowerShell binding Claude CLI flags such as --model/--effort
# to launcher-specific parameters.
$ClaudeArgs = @($args)

$ErrorActionPreference = "Stop"
$LifecycleRoot = $PSScriptRoot
$LifecycleRoot = (Resolve-Path -LiteralPath $LifecycleRoot).Path
Set-Location -LiteralPath $LifecycleRoot

if (-not (Test-Path -LiteralPath (Join-Path $LifecycleRoot "AGENTS.md"))) {
    throw "AGENTS.md was not found in lifecycle root: $LifecycleRoot"
}

if (-not $env:ANTHROPIC_API_KEY) {
    Write-Host "ANTHROPIC_API_KEY is not set for this PowerShell session." -ForegroundColor Yellow
    Write-Host ""
    Write-Host 'Set it for the current terminal only:'
    Write-Host '  $env:ANTHROPIC_API_KEY = "sk-ant-..."'
    Write-Host ""
    Write-Host "Do not store the API key in this repository or any committed file." -ForegroundColor DarkGray
    throw "Anthropic API key is required."
}

# Keep Codebase Memory scoped to the existing Digvation Lifecycle workspace.
# Existing CBM cache/runtime environment variables are intentionally left untouched,
# so this launcher reuses the same local Codebase Memory cache and index.
$env:CBM_ALLOWED_ROOT = $LifecycleRoot

# Force this launcher to use Anthropic's API directly rather than a previously
# configured custom Claude-compatible gateway. This is process-local only.
$env:ANTHROPIC_BASE_URL = "https://api.anthropic.com"

# GitHub Official plugin reads GITHUB_PERSONAL_ACCESS_TOKEN.
# Reuse the user's existing gh authentication for this process only; never persist the token.
if (-not $env:GITHUB_PERSONAL_ACCESS_TOKEN) {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if ($gh) {
        try {
            & gh auth status 1>$null 2>$null
            if ($LASTEXITCODE -eq 0) {
                $token = (& gh auth token 2>$null | Out-String).Trim()
                if ($token) {
                    $env:GITHUB_PERSONAL_ACCESS_TOKEN = $token
                    Write-Host "GitHub MCP credential: inherited from current gh login for this Claude process." -ForegroundColor DarkGray
                }
            }
        } catch {
            Write-Host "GitHub MCP credential: gh is present but not authenticated." -ForegroundColor Yellow
        }
    }
}

$claude = Get-Command claude -ErrorAction SilentlyContinue
if (-not $claude) {
    throw "Claude Code CLI ('claude') is not available in PATH."
}

Write-Host "Starting Claude Code with Anthropic API billing from Digvation lifecycle root:" -ForegroundColor Cyan
Write-Host "  $LifecycleRoot"
Write-Host ""
Write-Host "Context/caching:" -ForegroundColor DarkGray
Write-Host "  - existing .claude skills/settings/hooks are reused" -ForegroundColor DarkGray
Write-Host "  - existing Graphify configuration/cache is reused" -ForegroundColor DarkGray
Write-Host "  - existing Codebase Memory cache/index is reused" -ForegroundColor DarkGray
Write-Host "  - Claude Code prompt caching remains managed by Claude Code/API" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Anthropic API key: configured for this process (value hidden)." -ForegroundColor DarkGray
if ($ClaudeArgs.Count -gt 0) {
    Write-Host "Claude arguments: $($ClaudeArgs -join ' ')" -ForegroundColor DarkGray
}
Write-Host ""

& claude @ClaudeArgs
exit $LASTEXITCODE
