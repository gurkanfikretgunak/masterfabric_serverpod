#!/bin/bash
# Run server with cleaner log output
# Filters out async suspension lines and abbreviated stack traces

cd "$(dirname "$0")/.." || exit 1

echo "Starting server with clean logs..."
echo "Press Ctrl+C to stop"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

dart run bin/main.dart 2>&1 | while IFS= read -r line; do
  # Skip async suspension lines
  if [[ "$line" == *"<asynchronous suspension>"* ]]; then
    continue
  fi
  
  # Skip stack trace lines (start with #0, #1, etc.)
  if [[ "$line" =~ ^#[0-9] ]]; then
    continue
  fi
  
  # Skip empty lines after filtered content
  if [[ -z "$line" ]]; then
    continue
  fi
  
  # Add colors for different log levels
  if [[ "$line" == *"ERROR"* ]]; then
    echo -e "\033[31m$line\033[0m"  # Red
  elif [[ "$line" == *"WARNING"* ]] || [[ "$line" == *"RATE LIMITED"* ]] || [[ "$line" == *"⚡"* ]]; then
    echo -e "\033[33m$line\033[0m"  # Yellow
  elif [[ "$line" == *"INFO"* ]] || [[ "$line" == *"✓"* ]]; then
    echo -e "\033[32m$line\033[0m"  # Green
  elif [[ "$line" == *"DEBUG"* ]]; then
    echo -e "\033[90m$line\033[0m"  # Gray
  else
    echo "$line"
  fi
done
