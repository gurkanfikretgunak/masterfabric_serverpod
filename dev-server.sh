#!/bin/bash
#
# MasterFabric Serverpod - Server Only Development
# =================================================
# Quick start for backend development (no Flutter)
#

set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$ROOT_DIR/masterfabric_serverpod_server"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  MasterFabric Serverpod - Server Development${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cd "$SERVER_DIR"

# Step 1: Docker
echo -e "${YELLOW}[1/3]${NC} Starting Docker services..."
if docker compose version &>/dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi
echo -e "${GREEN}✓${NC} Docker services running"

# Wait for services
echo -e "${GRAY}  Waiting for PostgreSQL...${NC}"
while ! nc -z localhost 8090 2>/dev/null; do sleep 1; done
echo -e "${GRAY}  Waiting for Redis...${NC}"
while ! nc -z localhost 8091 2>/dev/null; do sleep 1; done

# Step 2: Generate
echo -e "${YELLOW}[2/3]${NC} Generating Serverpod code..."
dart pub get --no-example > /dev/null 2>&1
serverpod generate > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Code generated"

# Step 3: Run server with clean logs
echo -e "${YELLOW}[3/3]${NC} Starting server..."
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Server ready at http://localhost:8080${NC}"
echo -e "${GREEN}  Insights at http://localhost:8081${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Run with filtered logs
exec dart run bin/main.dart 2>&1 | while IFS= read -r line; do
    [[ "$line" == *"<asynchronous suspension>"* ]] && continue
    [[ "$line" =~ ^#[0-9] ]] && continue
    [[ "$line" == *"ERROR"* ]] && echo -e "\033[31m$line\033[0m" && continue
    [[ "$line" == *"WARNING"* || "$line" == *"⚡"* ]] && echo -e "\033[33m$line\033[0m" && continue
    echo -e "\033[90m$line\033[0m"
done
