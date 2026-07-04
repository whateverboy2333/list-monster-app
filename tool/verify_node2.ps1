$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$flutter = "flutter"
$dart = "dart"

function Invoke-Checked {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Command,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
  )

  & $Command @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "$Command $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
  }
}

$dartPackages = @(
  "packages/core",
  "packages/task_domain",
  "packages/monster_domain",
  "packages/local_store",
  "packages/sync_domain",
  "packages/companion_contract"
)

$flutterPackages = @(
  "packages/sprite_runtime",
  "packages/ui_kit"
)

Push-Location $root
try {
  Invoke-Checked $flutter "--version"
  Invoke-Checked $dart "--version"

  Push-Location "apps/list_monster_app"
  Invoke-Checked $flutter "pub" "get"
  Invoke-Checked $dart "analyze"
  Invoke-Checked $flutter "test"
  Pop-Location

  foreach ($package in $dartPackages) {
    Push-Location $package
    Invoke-Checked $dart "pub" "get"
    Invoke-Checked $dart "analyze"
    Invoke-Checked $dart "test"
    Pop-Location
  }

  foreach ($package in $flutterPackages) {
    Push-Location $package
    Invoke-Checked $flutter "pub" "get"
    Invoke-Checked $dart "analyze"
    Invoke-Checked $flutter "test"
    Pop-Location
  }
}
finally {
  Pop-Location
}
