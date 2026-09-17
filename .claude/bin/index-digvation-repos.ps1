# DIGVATION_CLAUDE_BOOTSTRAP
[CmdletBinding()]
param(
    [string]$LifecycleRoot = (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
)

$ErrorActionPreference = "Stop"
$LifecycleRoot = (Resolve-Path -LiteralPath $LifecycleRoot).Path

$cbm = Get-Command codebase-memory-mcp -ErrorAction SilentlyContinue
if (-not $cbm) {
    $candidate = Join-Path $env:LOCALAPPDATA "Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
    if (Test-Path $candidate) { $cbm = Get-Item $candidate }
}
if (-not $cbm) {
    throw "codebase-memory-mcp was not found. Run the bootstrap installer first."
}

$cbmPath = if ($cbm.PSObject.Properties.Name -contains "Source" -and $cbm.Source) {
    $cbm.Source
} elseif ($cbm.PSObject.Properties.Name -contains "FullName" -and $cbm.FullName) {
    $cbm.FullName
} else {
    $cbm.ToString()
}

$repos = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)

function Add-RepoIfPresent([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return }
    $gitMarker = Join-Path $Path ".git"
    if (Test-Path -LiteralPath $gitMarker) {
        try {
            $top = (& git -C $Path rev-parse --show-toplevel 2>$null | Out-String).Trim()
            if ($top) { [void]$repos.Add((Resolve-Path $top).Path) }
        } catch {}
    }
}

Add-RepoIfPresent $LifecycleRoot

# Digvation is an orchestration root with nested repositories. Discover only a
# shallow workspace topology so node_modules/build output is never recursively scanned.
$level1 = Get-ChildItem -LiteralPath $LifecycleRoot -Directory -Force -ErrorAction SilentlyContinue
foreach ($d1 in $level1) {
    Add-RepoIfPresent $d1.FullName
    $level2 = Get-ChildItem -LiteralPath $d1.FullName -Directory -Force -ErrorAction SilentlyContinue
    foreach ($d2 in $level2) { Add-RepoIfPresent $d2.FullName }
}

if ($repos.Count -eq 0) {
    throw "No Git repositories found below $LifecycleRoot"
}

$env:CBM_ALLOWED_ROOT = $LifecycleRoot

Write-Host "Indexing Digvation repositories as separate Codebase Memory projects:" -ForegroundColor Cyan
foreach ($repo in ($repos | Sort-Object)) {
    Write-Host "  -> $repo"
    $payload = @{ repo_path = $repo } | ConvertTo-Json -Compress
    & $cbmPath cli index_repository $payload
    if ($LASTEXITCODE -ne 0) {
        throw "Codebase Memory indexing failed for $repo"
    }
}

Write-Host ""
Write-Host "Indexed projects:" -ForegroundColor Cyan
& $cbmPath cli list_projects

