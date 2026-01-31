#!/bin/bash
#
# MasterFabric Serverpod - Local Development Runner
# ==================================================
# This script sets up and runs the complete development environment:
#   0. Docker services (Postgres + Redis)
#   1. Serverpod code generation
#   2. Server startup
#   3. Flutter app launch
#

set -e

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVER_DIR="$ROOT_DIR/masterfabric_serverpod_server"
FLUTTER_DIR="$ROOT_DIR/masterfabric_serverpod_flutter"
CLIENT_DIR="$ROOT_DIR/masterfabric_serverpod_client"

# Ports
POSTGRES_PORT=8090
REDIS_PORT=8091
SERVER_PORT=8080

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Icons
ICON_CHECK="✓"
ICON_CROSS="✗"
ICON_ARROW="→"
ICON_WAIT="⏳"
ICON_DOCKER="🐳"
ICON_SERVER="🖥"
ICON_FLUTTER="📱"
ICON_BUILD="🔧"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helper Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${BLUE}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_step() {
    echo -e "\n${MAGENTA}${BOLD}[$1]${NC} ${YELLOW}$2${NC}"
}

print_info() {
    echo -e "  ${GRAY}${ICON_ARROW}${NC} $1"
}

print_success() {
    echo -e "  ${GREEN}${ICON_CHECK}${NC} $1"
}

print_error() {
    echo -e "  ${RED}${ICON_CROSS}${NC} $1"
}

print_wait() {
    echo -e "  ${YELLOW}${ICON_WAIT}${NC} $1"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

wait_for_port() {
    local port=$1
    local name=$2
    local max_attempts=30
    local attempt=1
    
    print_wait "Waiting for $name on port $port..."
    
    while ! nc -z localhost "$port" 2>/dev/null; do
        if [ $attempt -ge $max_attempts ]; then
            print_error "$name failed to start on port $port"
            return 1
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    
    print_success "$name is ready on port $port"
    return 0
}

cleanup() {
    echo ""
    print_header "Shutting down..."
    
    # Kill background processes
    if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        print_info "Stopping server (PID: $SERVER_PID)..."
        kill "$SERVER_PID" 2>/dev/null || true
    fi
    
    if [ -n "$FLUTTER_PID" ] && kill -0 "$FLUTTER_PID" 2>/dev/null; then
        print_info "Stopping Flutter app (PID: $FLUTTER_PID)..."
        kill "$FLUTTER_PID" 2>/dev/null || true
    fi
    
    print_success "Cleanup complete"
    echo -e "${GRAY}Docker containers are still running. Stop with: docker-compose -f $SERVER_DIR/docker-compose.yaml down${NC}"
    exit 0
}

# Trap Ctrl+C
trap cleanup SIGINT SIGTERM

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Main Script
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo -e "${BOLD}${CYAN}  ╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}  ║                                                                       ║${NC}"
echo -e "${BOLD}${CYAN}  ║   ${MAGENTA}MasterFabric Serverpod${CYAN}                                            ║${NC}"
echo -e "${BOLD}${CYAN}  ║   ${GRAY}Local Development Environment${CYAN}                                     ║${NC}"
echo -e "${BOLD}${CYAN}  ║                                                                       ║${NC}"
echo -e "${BOLD}${CYAN}  ╚═══════════════════════════════════════════════════════════════════════╝${NC}"

# ─────────────────────────────────────────────────────────────────────────────
# Step 0: Prerequisites Check
# ─────────────────────────────────────────────────────────────────────────────

print_step "0" "Checking prerequisites..."

# Check Docker
if check_command docker; then
    print_success "Docker is installed"
else
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if check_command docker-compose || docker compose version &>/dev/null; then
    print_success "Docker Compose is available"
else
    print_error "Docker Compose is not available. Please install Docker Compose."
    exit 1
fi

# Check Dart
if check_command dart; then
    DART_VERSION=$(dart --version 2>&1 | head -n1)
    print_success "Dart: $DART_VERSION"
else
    print_error "Dart is not installed. Please install Dart SDK."
    exit 1
fi

# Check Flutter
if check_command flutter; then
    FLUTTER_VERSION=$(flutter --version 2>&1 | head -n1)
    print_success "Flutter: $FLUTTER_VERSION"
else
    print_error "Flutter is not installed. Please install Flutter SDK."
    exit 1
fi

# Check Serverpod CLI
if check_command serverpod; then
    print_success "Serverpod CLI is installed"
else
    print_error "Serverpod CLI is not installed. Install with: dart pub global activate serverpod_cli"
    exit 1
fi

# ─────────────────────────────────────────────────────────────────────────────
# Step 1: Start Docker Services
# ─────────────────────────────────────────────────────────────────────────────

print_step "1" "${ICON_DOCKER} Starting Docker services..."

cd "$SERVER_DIR"

# Check if containers are already running
POSTGRES_RUNNING=$(docker ps -q -f name=masterfabric_serverpod_server-postgres-1 2>/dev/null || docker ps -q -f name=masterfabric_serverpod_server_postgres_1 2>/dev/null || echo "")
REDIS_RUNNING=$(docker ps -q -f name=masterfabric_serverpod_server-redis-1 2>/dev/null || docker ps -q -f name=masterfabric_serverpod_server_redis_1 2>/dev/null || echo "")

if [ -n "$POSTGRES_RUNNING" ] && [ -n "$REDIS_RUNNING" ]; then
    print_success "Docker containers already running"
else
    print_info "Starting Docker containers..."
    
    # Try docker compose (v2) first, then docker-compose (v1)
    if docker compose version &>/dev/null; then
        docker compose up -d
    else
        docker-compose up -d
    fi
    
    print_success "Docker containers started"
fi

# Wait for services to be ready
wait_for_port $POSTGRES_PORT "PostgreSQL" || exit 1
wait_for_port $REDIS_PORT "Redis" || exit 1

# ─────────────────────────────────────────────────────────────────────────────
# Step 2: Install Dependencies & Generate Code
# ─────────────────────────────────────────────────────────────────────────────

print_step "2" "${ICON_BUILD} Installing dependencies & generating code..."

# Server dependencies
print_info "Installing server dependencies..."
cd "$SERVER_DIR"
dart pub get --no-example > /dev/null 2>&1
print_success "Server dependencies installed"

# Client dependencies  
print_info "Installing client dependencies..."
cd "$CLIENT_DIR"
dart pub get > /dev/null 2>&1
print_success "Client dependencies installed"

# Flutter dependencies
print_info "Installing Flutter dependencies..."
cd "$FLUTTER_DIR"
flutter pub get > /dev/null 2>&1
print_success "Flutter dependencies installed"

# Generate Serverpod code
print_info "Generating Serverpod code..."
cd "$SERVER_DIR"
serverpod generate > /dev/null 2>&1
print_success "Serverpod code generated"

# ─────────────────────────────────────────────────────────────────────────────
# Step 3: Start Server
# ─────────────────────────────────────────────────────────────────────────────

print_step "3" "${ICON_SERVER} Starting Serverpod server..."

cd "$SERVER_DIR"

# Check if server is already running
if nc -z localhost $SERVER_PORT 2>/dev/null; then
    print_info "Server already running on port $SERVER_PORT"
else
    print_info "Starting server in background..."
    
    # Start server with clean logs
    dart run bin/main.dart 2>&1 | while IFS= read -r line; do
        # Skip async suspension and stack traces for cleaner output
        if [[ "$line" == *"<asynchronous suspension>"* ]] || [[ "$line" =~ ^#[0-9] ]]; then
            continue
        fi
        # Color code output
        if [[ "$line" == *"ERROR"* ]]; then
            echo -e "${RED}$line${NC}"
        elif [[ "$line" == *"WARNING"* ]] || [[ "$line" == *"⚡"* ]]; then
            echo -e "${YELLOW}$line${NC}"
        elif [[ "$line" == *"Server started"* ]] || [[ "$line" == *"✓"* ]]; then
            echo -e "${GREEN}$line${NC}"
        else
            echo -e "${GRAY}$line${NC}"
        fi
    done &
    SERVER_PID=$!
    
    # Wait for server to be ready
    wait_for_port $SERVER_PORT "Serverpod" || exit 1
fi

print_success "Server running at http://localhost:$SERVER_PORT"

# ─────────────────────────────────────────────────────────────────────────────
# Step 4: Start Flutter App
# ─────────────────────────────────────────────────────────────────────────────

print_step "4" "${ICON_FLUTTER} Starting Flutter app..."

cd "$FLUTTER_DIR"

print_info "Launching Flutter app..."

# Detect available devices
DEVICES=$(flutter devices 2>/dev/null | grep -v "No devices" | tail -n +2)

if [ -z "$DEVICES" ]; then
    print_error "No Flutter devices available"
    print_info "Starting Flutter in Chrome (web)..."
    flutter run -d chrome &
    FLUTTER_PID=$!
else
    # Run on first available device or Chrome
    if echo "$DEVICES" | grep -q "chrome"; then
        print_info "Running on Chrome..."
        flutter run -d chrome &
        FLUTTER_PID=$!
    elif echo "$DEVICES" | grep -q "macos"; then
        print_info "Running on macOS..."
        flutter run -d macos &
        FLUTTER_PID=$!
    else
        print_info "Running on first available device..."
        flutter run &
        FLUTTER_PID=$!
    fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# Ready
# ─────────────────────────────────────────────────────────────────────────────

print_header "Development Environment Ready!"

echo ""
echo -e "  ${CYAN}Services:${NC}"
echo -e "    ${GREEN}${ICON_CHECK}${NC} PostgreSQL     ${GRAY}localhost:${POSTGRES_PORT}${NC}"
echo -e "    ${GREEN}${ICON_CHECK}${NC} Redis          ${GRAY}localhost:${REDIS_PORT}${NC}"
echo -e "    ${GREEN}${ICON_CHECK}${NC} API Server     ${GRAY}http://localhost:${SERVER_PORT}${NC}"
echo -e "    ${GREEN}${ICON_CHECK}${NC} Insights       ${GRAY}http://localhost:8081${NC}"
echo -e "    ${GREEN}${ICON_CHECK}${NC} Web Server     ${GRAY}http://localhost:8082${NC}"
echo ""
echo -e "  ${CYAN}Quick Commands:${NC}"
echo -e "    ${GRAY}Stop all:${NC}        ${YELLOW}Ctrl+C${NC}"
echo -e "    ${GRAY}Regenerate:${NC}      ${YELLOW}cd $SERVER_DIR && serverpod generate${NC}"
echo -e "    ${GRAY}Stop Docker:${NC}     ${YELLOW}cd $SERVER_DIR && docker compose down${NC}"
echo ""
echo -e "  ${GRAY}Press Ctrl+C to stop all services...${NC}"
echo ""

# Wait for processes
wait
