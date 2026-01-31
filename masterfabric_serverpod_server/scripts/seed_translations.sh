#!/bin/bash

# Script to seed translations from JSON files
# Usage: ./scripts/seed_translations.sh [locale] [namespace]
#   locale: en, tr, de, etc. (or --all to seed all)
#   namespace: optional namespace identifier

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Check if dart is available
if ! command -v dart &> /dev/null; then
    echo -e "${RED}Error: dart is not installed${NC}"
    exit 1
fi

# Check if server is running (optional check)
echo -e "${BLUE}🌍 Translation Seeder${NC}"
echo -e "${YELLOW}===================${NC}"
echo ""

# Change to project directory
cd "$PROJECT_DIR"

# Check if assets/i18n directory exists
if [ ! -d "assets/i18n" ]; then
    echo -e "${YELLOW}Creating assets/i18n directory...${NC}"
    mkdir -p assets/i18n
    echo -e "${GREEN}✅ Created assets/i18n directory${NC}"
    echo -e "${YELLOW}💡 Tip: Add your translation JSON files here (e.g., en.i18n.json, tr.i18n.json)${NC}"
    echo ""
fi

# Run the Dart script with all arguments
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}No arguments provided. Seeding all translations...${NC}"
    echo ""
    dart bin/seed_translations.dart --all
else
    dart bin/seed_translations.dart "$@"
fi

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✨ Done!${NC}"
else
    echo ""
    echo -e "${RED}❌ Failed to seed translations${NC}"
    exit 1
fi
