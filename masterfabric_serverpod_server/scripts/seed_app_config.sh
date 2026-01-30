#!/bin/bash

# Script to seed app_config_entry table with default configurations
# Usage: ./scripts/seed_app_config.sh [environment]
#   environment: development, staging, production, or all (default: all)

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
SEED_FILE="$PROJECT_DIR/migrations/seed_app_config.sql"

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose is not installed${NC}"
    exit 1
fi

# Check if seed file exists
if [ ! -f "$SEED_FILE" ]; then
    echo -e "${RED}Error: Seed file not found at $SEED_FILE${NC}"
    exit 1
fi

# Function to seed database
seed_database() {
    local env=$1
    echo -e "${YELLOW}🌱 Seeding app_config_entry table...${NC}"
    
    # Check if postgres container is running
    if ! docker-compose ps postgres | grep -q "Up"; then
        echo -e "${RED}Error: PostgreSQL container is not running${NC}"
        echo -e "${YELLOW}Starting PostgreSQL container...${NC}"
        docker-compose up -d postgres
        echo -e "${YELLOW}Waiting for PostgreSQL to be ready...${NC}"
        sleep 5
    fi
    
    # Execute the seed file
    echo -e "${YELLOW}Executing seed SQL file...${NC}"
    if docker-compose exec -T postgres psql -U postgres -d masterfabric_serverpod < "$SEED_FILE"; then
        echo -e "${GREEN}✅ Successfully seeded app_config_entry table!${NC}"
        
        # Verify the data
        echo -e "${YELLOW}📊 Verifying seeded data...${NC}"
        docker-compose exec postgres psql -U postgres -d masterfabric_serverpod -c "
            SELECT 
                environment,
                platform,
                isActive,
                createdAt
            FROM app_config_entry
            ORDER BY environment, platform;
        "
    else
        echo -e "${RED}❌ Failed to seed database${NC}"
        exit 1
    fi
}

# Main execution
echo -e "${GREEN}🚀 App Config Seeder${NC}"
echo -e "${YELLOW}===================${NC}"
echo ""

seed_database

echo ""
echo -e "${GREEN}✨ Done!${NC}"
