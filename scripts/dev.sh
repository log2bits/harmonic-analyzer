#!/bin/bash

# Development helper script for Harmonic Analyzer

set -e

echo "🎵 Harmonic Analyzer Development Helper"
echo "======================================"

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "❌ Docker is not running. Please start Docker first."
  exit 1
fi

# Function to rebuild WASM
rebuild_wasm() {
  echo "🔧 Rebuilding WASM module..."
  docker-compose run --rm rust-dev wasm-pack build --target web --out-dir www/pkg
  echo "✅ WASM module rebuilt!"
}

# Function to run tests
run_tests() {
  echo "🧪 Running tests..."
  docker-compose run --rm test
  echo "✅ Tests completed!"
}

# Function to start development server
start_dev() {
  echo "🚀 Starting development server..."
  echo "📱 Open http://localhost:8000 in your browser"
  docker-compose up --build dev
}

# Main menu
case "${1:-}" in
"wasm" | "rebuild")
  rebuild_wasm
  ;;
"test")
  run_tests
  ;;
"dev" | "start")
  start_dev
  ;;
"shell")
  echo "🐚 Opening Rust development shell..."
  docker-compose run --rm rust-dev bash
  ;;
*)
  echo "Usage: $0 {dev|wasm|test|shell}"
  echo ""
  echo "Commands:"
  echo "  dev     - Start development server"
  echo "  wasm    - Rebuild WASM module"
  echo "  test    - Run tests"
  echo "  shell   - Open Rust development shell"
  echo ""
  echo "Or use 'make' commands directly:"
  echo "  make dev, make test, make rebuild-wasm, etc."
  ;;
esac
