# Harmonic Analyzer Docker Commands

.PHONY: help build dev prod test clean rebuild-wasm shell

# Default target
help:
	@echo "Available commands:"
	@echo "  make dev          - Start development server"
	@echo "  make prod         - Start production server"
	@echo "  make test         - Run tests in container"
	@echo "  make build        - Build all Docker images"
	@echo "  make rebuild-wasm - Rebuild WASM module"
	@echo "  make shell        - Open shell in Rust container"
	@echo "  make clean        - Clean up containers and images"

# Start development server
dev:
	docker-compose up --build dev

# Start production server
prod:
	docker-compose up --build prod

# Run tests
test:
	docker-compose run --rm test

# Build all images
build:
	docker-compose build

# Rebuild WASM module during development
rebuild-wasm:
	docker-compose run --rm rust-dev wasm-pack build --target web --out-dir www/pkg

# Open shell in Rust container for development
shell:
	docker-compose run --rm rust-dev bash

# Run Rust tests specifically
test-rust:
	docker-compose run --rm rust-dev cargo test

# Run WASM tests
test-wasm:
	docker-compose run --rm rust-dev wasm-pack test --headless --firefox

# Clean up
clean:
	docker-compose down --rmi all --volumes --remove-orphans
	docker system prune -f

# Full rebuild (clean + build)
rebuild: clean build
