# PowerShell script to seed app_config_entry table with default configurations
# Usage: .\scripts\seed_app_config.ps1

$ErrorActionPreference = "Stop"

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
$SeedFile = Join-Path $ProjectDir "migrations\seed_app_config.sql"

# Check if docker-compose is available
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-ColorOutput Red "Error: docker-compose is not installed"
    exit 1
}

# Check if seed file exists
if (-not (Test-Path $SeedFile)) {
    Write-ColorOutput Red "Error: Seed file not found at $SeedFile"
    exit 1
}

# Function to seed database
function Seed-Database {
    Write-ColorOutput Yellow "🌱 Seeding app_config_entry table..."
    
    # Check if postgres container is running
    $postgresStatus = docker-compose ps postgres 2>&1
    if ($postgresStatus -notmatch "Up") {
        Write-ColorOutput Yellow "PostgreSQL container is not running. Starting it..."
        docker-compose up -d postgres
        Write-ColorOutput Yellow "Waiting for PostgreSQL to be ready..."
        Start-Sleep -Seconds 5
    }
    
    # Execute the seed file
    Write-ColorOutput Yellow "Executing seed SQL file..."
    Get-Content $SeedFile | docker-compose exec -T postgres psql -U postgres -d masterfabric_serverpod
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "✅ Successfully seeded app_config_entry table!"
        
        # Verify the data
        Write-ColorOutput Yellow "📊 Verifying seeded data..."
        docker-compose exec postgres psql -U postgres -d masterfabric_serverpod -c @"
            SELECT 
                environment,
                platform,
                isActive,
                createdAt
            FROM app_config_entry
            ORDER BY environment, platform;
"@
    } else {
        Write-ColorOutput Red "❌ Failed to seed database"
        exit 1
    }
}

# Main execution
Write-ColorOutput Green "🚀 App Config Seeder"
Write-ColorOutput Yellow "==================="
Write-Output ""

Seed-Database

Write-Output ""
Write-ColorOutput Green "✨ Done!"
