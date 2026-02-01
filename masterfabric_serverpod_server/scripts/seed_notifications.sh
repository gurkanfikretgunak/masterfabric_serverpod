#!/bin/bash

# Script to seed notification channels and demo notifications
# Usage: ./scripts/seed_notifications.sh [options]
#   options: --channels, --demo, --clear, --help

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

echo -e "${CYAN}🔔 Notification Seeder${NC}"
echo -e "${CYAN}=====================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "$PROJECT_DIR/pubspec.yaml" ]; then
    echo -e "${RED}Error: pubspec.yaml not found. Are you in the server directory?${NC}"
    exit 1
fi

cd "$PROJECT_DIR"

# Run the Dart seed script
echo -e "${YELLOW}Running seed script...${NC}"
echo ""

if dart run bin/seed_notifications.dart "$@"; then
    echo ""
    echo -e "${GREEN}✨ Seeding complete!${NC}"
else
    echo ""
    echo -e "${RED}❌ Seeding failed${NC}"
    exit 1
fi
