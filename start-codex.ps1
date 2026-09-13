$ErrorActionPreference = "Stop"

$cbmDir = "$env:LOCALAPPDATA\Programs\codebase-memory-mcp"
$cbmExe = Join-Path $cbmDir "codebase-memory-mcp.exe"

if (-not (Test-Path $cbmExe)) {
    Write-Host ""
    Write-Host "Codebase Memory MCP tidak ditemukan:"
    Write-Host $cbmExe
    Write-Host ""
    exit 1
}

# Simpan PATH asli.
$originalPath = $env:Path

try {
    # Tambahkan CBM hanya untuk session script ini + child process Codex.
    if (($env:Path -split ";") -notcontains $cbmDir) {
        $env:Path = "$cbmDir;$env:Path"
    }

    Set-Location $PSScriptRoot

    Write-Host ""
    Write-Host "========================================"
    Write-Host " Digvation Codex + Codebase Memory"
    Write-Host "========================================"
    Write-Host ""

    Write-Host "Checking Codebase Memory..."
    & $cbmExe --version

    Write-Host ""
    Write-Host "Checking Codex MCP configuration..."
    codex mcp list

    Write-Host ""
    Write-Host "Starting Codex..."
    Write-Host ""

    codex @args
}
finally {
    # Kembalikan PATH seperti semula setelah Codex selesai.
    $env:Path = $originalPath
}