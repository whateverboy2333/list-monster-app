[CmdletBinding()]
param(
    [ValidateSet('Release', 'Profile', 'Debug')]
    [string]$Mode = 'Release',
    [string]$Flutter,
    [switch]$SkipClean,
    [switch]$Run
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-FlutterCommand {
    param([string]$RequestedCommand)

    if ($RequestedCommand) {
        $resolved = Get-Command $RequestedCommand -ErrorAction SilentlyContinue
        if ($resolved) {
            return $resolved.Source
        }
        if (Test-Path -LiteralPath $RequestedCommand -PathType Leaf) {
            return (Resolve-Path -LiteralPath $RequestedCommand).Path
        }
        throw "Flutter command not found: $RequestedCommand"
    }

    foreach ($name in @('flutter.bat', 'flutter')) {
        $resolved = Get-Command $name -ErrorAction SilentlyContinue
        if ($resolved) {
            return $resolved.Source
        }
    }

    $candidates = @()
    if ($env:FLUTTER_ROOT) {
        $candidates += (Join-Path $env:FLUTTER_ROOT 'bin\flutter.bat')
    }
    if ($env:USERPROFILE) {
        $candidates += (Join-Path $env:USERPROFILE 'tools\flutter\bin\flutter.bat')
    }
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }

    throw 'Flutter was not found. Add Flutter to PATH, set FLUTTER_ROOT, or pass -Flutter.'
}

function Get-PathHash {
    param([string]$Value)

    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
        $digest = $sha.ComputeHash($bytes)
        return ([System.BitConverter]::ToString($digest) -replace '-', '').Substring(0, 8).ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Resolve-AsciiBuildRoot {
    param([string]$RepositoryRoot)

    if ($RepositoryRoot -notmatch '[^\x00-\x7F]') {
        return $RepositoryRoot
    }

    $aliasParent = Split-Path -Parent $RepositoryRoot
    while ($aliasParent -match '[^\x00-\x7F]') {
        $nextParent = Split-Path -Parent $aliasParent
        if ([string]::IsNullOrWhiteSpace($nextParent) -or $nextParent -eq $aliasParent) {
            throw "Could not find an ASCII parent directory for $RepositoryRoot"
        }
        $aliasParent = $nextParent
    }

    $aliasPath = Join-Path $aliasParent "list-monster-build-$(Get-PathHash $RepositoryRoot)"
    if (Test-Path -LiteralPath $aliasPath) {
        $item = Get-Item -LiteralPath $aliasPath -Force
        if ($item.LinkType -ne 'Junction') {
            throw "ASCII build path already exists and is not a junction: $aliasPath"
        }
        $target = (Resolve-Path -LiteralPath ([string]$item.Target)).Path
        if (-not [string]::Equals($target, $RepositoryRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "ASCII build junction points to a different repository: $aliasPath"
        }
    }
    else {
        New-Item -ItemType Junction -Path $aliasPath -Target $RepositoryRoot | Out-Null
    }

    Write-Host "Using ASCII build path: $aliasPath"
    return $aliasPath
}

function Invoke-Flutter {
    param(
        [string]$Command,
        [string[]]$Arguments
    )

    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter command failed: flutter $($Arguments -join ' ')"
    }
}

function Copy-ReleaseRuntime {
    param([string]$Destination)

    $visualStudioRoot = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\2022'
    $redistRoots = Get-ChildItem -LiteralPath $visualStudioRoot -Directory -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'VC\Redist\MSVC' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Container }

    foreach ($redistRoot in $redistRoots) {
        $crtDirectory = Get-ChildItem -LiteralPath $redistRoot -Directory |
            Sort-Object Name -Descending |
            ForEach-Object { Join-Path $_.FullName 'x64\Microsoft.VC143.CRT' } |
            Where-Object { Test-Path -LiteralPath $_ -PathType Container } |
            Select-Object -First 1
        if ($crtDirectory) {
            Copy-Item -Path (Join-Path $crtDirectory '*.dll') -Destination $Destination -Force
            Write-Host "Bundled Visual C++ runtime from: $crtDirectory"
            return
        }
    }

    Write-Warning 'Visual C++ release runtime was not found. Install the VC++ 2015-2022 x64 redistributable on target PCs.'
}

$repositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$runningApps = Get-Process -Name 'list_monster_app' -ErrorAction SilentlyContinue
if ($runningApps) {
    throw 'Close List Monster and its desktop pet before building Windows.'
}

$flutterCommand = Resolve-FlutterCommand $Flutter
$buildRoot = Resolve-AsciiBuildRoot $repositoryRoot
$appRoot = Join-Path $buildRoot 'apps\list_monster_app'
$modeArgument = "--$($Mode.ToLowerInvariant())"

Push-Location $appRoot
try {
    if (-not $SkipClean) {
        Invoke-Flutter $flutterCommand @('clean')
    }
    Invoke-Flutter $flutterCommand @('pub', 'get')
    Invoke-Flutter $flutterCommand @('build', 'windows', $modeArgument)
}
finally {
    Pop-Location
}

$sourceBundle = Join-Path $appRoot "build\windows\x64\runner\$Mode"
if (-not (Test-Path -LiteralPath $sourceBundle -PathType Container)) {
    throw "Windows build output not found: $sourceBundle"
}

$launchPath = Join-Path $sourceBundle 'list_monster_app.exe'
if ($Mode -eq 'Release') {
    $distParent = Join-Path $repositoryRoot 'dist\windows'
    $distBundle = Join-Path $distParent 'list_monster_app'
    $zipPath = Join-Path $distParent 'list_monster_app-windows-x64.zip'
    New-Item -ItemType Directory -Path $distParent -Force | Out-Null

    if (Test-Path -LiteralPath $distBundle) {
        $expectedPrefix = [System.IO.Path]::GetFullPath($distParent).TrimEnd('\') + '\'
        $resolvedDist = [System.IO.Path]::GetFullPath($distBundle)
        if (-not $resolvedDist.StartsWith($expectedPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to replace unexpected distribution path: $resolvedDist"
        }
        Remove-Item -LiteralPath $distBundle -Recurse -Force
    }

    Copy-Item -LiteralPath $sourceBundle -Destination $distBundle -Recurse
    Copy-ReleaseRuntime $distBundle
    if (Test-Path -LiteralPath $zipPath) {
        Remove-Item -LiteralPath $zipPath -Force
    }
    Compress-Archive -Path (Join-Path $distBundle '*') -DestinationPath $zipPath -CompressionLevel Optimal
    $launchPath = Join-Path $distBundle 'list_monster_app.exe'
    Write-Host "Release bundle: $distBundle"
    Write-Host "Release archive: $zipPath"
}
elseif ($Mode -eq 'Debug') {
    Write-Warning 'Debug builds require Visual C++ debug libraries and must not be sent to testers. Use the default Release mode for distribution.'
}

if ($Run) {
    Start-Process -FilePath $launchPath -WorkingDirectory (Split-Path -Parent $launchPath)
}

Write-Host "Windows executable: $launchPath"
