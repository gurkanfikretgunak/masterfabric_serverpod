# Script to seed translations from JSON files
# Usage: .\scripts\seed_translations.ps1 [locale] [namespace]
#   locale: en, tr, de, etc. (or --all to seed all)
#   namespace: optional namespace identifier

param(
    [Parameter(Position=0)]
    [string]$Locale = "",
    
    [Parameter(Position=1)]
    [string]$Namespace = ""
)

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir

# Check if dart is available
if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-ColorOutput Red "Error: dart is not installed"
    exit 1
}

Write-ColorOutput Blue "🌍 Translation Seeder"
Write-ColorOutput Yellow "==================="
Write-Output ""

# Change to project directory
Set-Location $ProjectDir

# Check if assets/i18n directory exists
if (-not (Test-Path "assets/i18n")) {
    Write-ColorOutput Yellow "Creating assets/i18n directory..."
    New-Item -ItemType Directory -Path "assets/i18n" -Force | Out-Null
    Write-ColorOutput Green "✅ Created assets/i18n directory"
    Write-ColorOutput Yellow "💡 Tip: Add your translation JSON files here (e.g., en.i18n.json, tr.i18n.json)"
    Write-Output ""
}

# Build arguments
$arguments = @()
if ($Locale) {
    $arguments += $Locale
    if ($Namespace) {
        $arguments += $Namespace
    }
} else {
    $arguments += "--all"
}

# Run the Dart script
try {
    & dart bin/seed_translations.dart $arguments
    
    if ($LASTEXITCODE -eq 0) {
        Write-Output ""
        Write-ColorOutput Green "✨ Done!"
    } else {
        Write-Output ""
        Write-ColorOutput Red "❌ Failed to seed translations"
        exit 1
    }
} catch {
    Write-ColorOutput Red "Error: $_"
    exit 1
}
