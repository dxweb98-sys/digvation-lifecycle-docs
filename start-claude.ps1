# DIGVATION_CLAUDE_BOOTSTRAP
[CmdletBinding()]
param(
    [string]$LifecycleRoot = $PSScriptRoot,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$ClaudeArgs
)

$ErrorActionPreference = "Stop"
$LifecycleRoot = (Resolve-Path -LiteralPath $LifecycleRoot).Path
Set-Location -LiteralPath $LifecycleRoot

if (-not (Test-Path -LiteralPath (Join-Path $LifecycleRoot "AGENTS.md"))) {
    throw "AGENTS.md was not found in lifecycle root: $LifecycleRoot"
}

# Restrict Codebase Memory repository indexing to the Digvation workspace.
$env:CBM_ALLOWED_ROOT = $LifecycleRoot

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

Write-Host "Starting Claude Code from Digvation lifecycle root:" -ForegroundColor Cyan
Write-Host "  $LifecycleRoot"
Write-Host ""
& claude @ClaudeArgs
exit $LASTEXITCODE

