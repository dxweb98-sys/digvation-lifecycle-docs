#Requires -Version 5.1
<#
  Digvation local checkout reconciliation (Runtime + CORE).

  Every dirty file was proven IDENTICAL_TO_DEV or SUPERSEDED_BY_DEV and backed up outside the repos.
  This script re-checks every guard right before the destructive steps and stops on the first mismatch:
    1. HEAD is the expected commit
    2. origin/<dev> is the expected commit
    3. the index is empty
    4. the set of modified and untracked files is exactly the expected list
    5. every dirty file is byte-identical to its backup copy (nothing changed since the backup)
    6. every dirty path exists on origin/<dev>
  Only after all guards pass does it restore/remove the dirty files, switch to the dev branch,
  fast-forward it, and verify every file against origin.

  Old feature branches and stashes are NOT touched. No commit, push, reset, clean or branch deletion.
  Runtime runs first; if anything fails, the script stops before CORE.
#>
# Git writes normal progress to stderr; failures are detected through $LASTEXITCODE and explicit throws,
# and every cmdlet that can fail uses -ErrorAction Stop.
$ErrorActionPreference = 'Continue'

function Assert-Git([string]$What) {
  if ($LASTEXITCODE -ne 0) { throw "git failed: $What" }
}

function Assert-SameSet([string[]]$Actual, [string[]]$Expected, [string]$Label) {
  $a = (@($Actual | Where-Object { $_ }) | Sort-Object) -join "`n"
  $e = (@($Expected | Where-Object { $_ }) | Sort-Object) -join "`n"
  if ($a -ne $e) {
    Write-Host "Expected:`n$e`nActual:`n$a"
    throw "$Label do not match the expected list"
  }
}

$Root = (Get-ChildItem -LiteralPath $HOME -Directory -Filter 'digvation-reconcile-backup-*' -ErrorAction Stop |
  Sort-Object Name -Descending | Select-Object -First 1).FullName
if (-not $Root) { throw "No digvation-reconcile-backup-* folder found under $HOME" }
Write-Host "Backup root: $Root"

function Invoke-Reconcile {
  param(
    [string]$Name,
    [string]$RepoPath,
    [string]$BackupDir,
    [string]$ExpectedHead,
    [string]$DevBranch,
    [string]$ExpectedDev,
    [string[]]$Modified,
    [string[]]$Untracked
  )
  Write-Host "`n=== $Name ===" -ForegroundColor Cyan
  Set-Location -LiteralPath $RepoPath -ErrorAction Stop
  $all = @($Modified) + @($Untracked)

  git fetch origin; Assert-Git 'fetch'

  # Guard 1: HEAD
  $head = git rev-parse HEAD; Assert-Git 'rev-parse HEAD'
  if ($head -ne $ExpectedHead) { throw "$Name HEAD is $head, expected $ExpectedHead" }

  # Guard 2: origin dev did not move since review
  $dev = git rev-parse "origin/${DevBranch}"; Assert-Git "rev-parse origin/${DevBranch}"
  if ($dev -ne $ExpectedDev) { throw "$Name origin/${DevBranch} is $dev, expected $ExpectedDev (re-review needed)" }

  # Guard 3: index empty
  $staged = @(git diff --cached --name-only); Assert-Git 'diff --cached'
  if ($staged.Count -gt 0) { throw "$Name index is not empty: $($staged -join ', ')" }

  # Guard 4: dirty set is exactly the expected list
  Assert-SameSet @(git diff --name-only HEAD) $Modified "$Name modified files"
  Assert-SameSet @(git ls-files --others --exclude-standard) $Untracked "$Name untracked files"

  # Guard 5: nothing changed since the backup
  foreach ($p in $all) {
    $copy = Join-Path $BackupDir $p
    if (-not (Test-Path -LiteralPath $copy)) { throw "Backup copy missing: $copy" }
    if ((Get-FileHash -LiteralPath $p -ErrorAction Stop).Hash -ne (Get-FileHash -LiteralPath $copy -ErrorAction Stop).Hash) {
      throw "$p changed since the backup"
    }
  }

  # Guard 6: every dirty path exists on origin dev
  foreach ($p in $all) {
    git cat-file -e "origin/${DevBranch}:$p" 2>$null
    if ($LASTEXITCODE -ne 0) { throw "$p does not exist on origin/${DevBranch}" }
  }
  Write-Host "All guards passed." -ForegroundColor Green

  # DESTRUCTIVE: return modified tracked files to HEAD (backup verified above)
  git restore --source=HEAD --staged --worktree -- $Modified; Assert-Git 'restore'
  # DESTRUCTIVE: remove untracked files (backup verified above)
  Remove-Item -LiteralPath $Untracked -ErrorAction Stop

  $left = @(git status --porcelain --untracked-files=all)
  if ($left.Count -gt 0) { throw "$Name working tree not clean before switch: $($left -join '; ')" }

  git switch $DevBranch; Assert-Git "switch $DevBranch"
  git merge --ff-only "origin/${DevBranch}"; Assert-Git "merge --ff-only origin/${DevBranch}"

  # Verify
  $now = git rev-parse HEAD; Assert-Git 'rev-parse HEAD'
  if ($now -ne $ExpectedDev) { throw "$Name HEAD is $now after fast-forward, expected $ExpectedDev" }
  $left = @(git status --porcelain --untracked-files=all)
  if ($left.Count -gt 0) { throw "$Name working tree not clean after switch: $($left -join '; ')" }
  foreach ($p in $all) {
    if ((git hash-object -- $p) -eq (git rev-parse "origin/${DevBranch}:$p")) { Write-Host "OK   $p" }
    else { throw "DIFF $p" }
  }
  Write-Host "$Name reconciled: branch $DevBranch @ $now, clean." -ForegroundColor Green
}

Invoke-Reconcile -Name 'Runtime' `
  -RepoPath 'C:\Users\dicky\Documents\work\digvation\lifecycle\business\digvation-business-runtime' `
  -BackupDir (Join-Path $Root 'runtime\files') `
  -ExpectedHead '7061fae68e842ccfb7adc2a4e6ccc5efa864c401' `
  -DevBranch 'dev' `
  -ExpectedDev '25f49078241f22347ee2324b0220365f7989f82d' `
  -Modified @(
    'package.json',
    'src/integration/control-plane/core-entitlement-sync.service.ts'
  ) `
  -Untracked @(
    'scripts/unit/core-entitlement-sync.test.ts',
    'src/integration/control-plane/core-entitlement-vocabulary.ts'
  )

Invoke-Reconcile -Name 'CORE' `
  -RepoPath 'C:\Users\dicky\Documents\work\digvation\lifecycle\core\core-v2' `
  -BackupDir (Join-Path $Root 'core\files') `
  -ExpectedHead '0e37bfc489ba6366da5e93cbe81136a1494eac0e' `
  -DevBranch 'digvation-core-dev' `
  -ExpectedDev '2a8a9db072a23fabbfa9509fd92973520b22cac0' `
  -Modified @(
    '.env.example',
    'prisma/seed.ts',
    'src/config/api-docs.config.ts',
    'src/config/env.validation.spec.ts',
    'src/config/env.validation.ts',
    'src/infrastructure/observability/logging/logging.module.ts',
    'src/modules/capability/capability.service.spec.ts',
    'src/modules/product/product.service.spec.ts',
    'src/modules/product/product.service.ts'
  ) `
  -Untracked @(
    'src/infrastructure/mail/mail.service.spec.ts',
    'src/modules/capability/capability-catalog.ts',
    'src/modules/capability/capability-compatibility.policy.spec.ts',
    'src/modules/capability/capability-compatibility.policy.ts',
    'src/modules/runtime-binding/runtime-entitlement-vocabulary.spec.ts',
    'src/modules/runtime-binding/runtime-entitlement-vocabulary.ts'
  )

Write-Host "`nRECONCILE_COMPLETE: Runtime on dev @ 25f49078, CORE on digvation-core-dev @ 2a8a9db0." -ForegroundColor Green
Write-Host "Not touched: old feature branches, Runtime stashes, backup folder $Root."