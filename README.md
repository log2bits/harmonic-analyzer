## Harmonic Analyzer

A Rust + WebAssembly project for analyzing audio harmonics and designing optimal musical scales.

## Project Structure

```
├── src/
│   └── lib.rs              # Main Rust WASM module
├── tests/
│   └── wasm_tests.rs       # WASM-specific tests
├── www/
│   ├── index.html          # Web interface
│   ├── audio-processor.js  # JavaScript audio handling
│   └── package.json        # Web dependencies
├── docker/
│   └── nginx.conf          # Nginx configuration for production
├── scripts/
│   └── dev.sh              # Development helper script
├── Dockerfile              # Multi-stage Docker build
├── docker-compose.yml      # Docker services configuration
├── Makefile               # Docker command shortcuts
├── .dockerignore          # Docker build exclusions
├── Cargo.toml             # Rust dependencies
└── README.md
```

## Setup

### Option 1: Docker (Recommended)

1. **Prerequisites:**
   - Docker
   - Docker Compose

2. **Quick start:**
   ```bash
   # Start development server
   make dev
   # OR
   docker-compose up --build dev
   # OR use the helper script
   chmod +x scripts/dev.sh
   ./scripts/dev.sh dev
   ```

3. **Open in browser:**
   Navigate to `http://localhost:8000`

### Option 2: Local Development

1. **Install Rust and wasm-pack:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
   ```

2. **Build the WASM module:**
   ```bash
   wasm-pack build --target web --out-dir www/pkg
   ```

3. **Serve the web app:**
   ```bash
   cd www
   python3 -m http.server 8000
   ```

## Docker Commands

```bash
# Development
make dev                # Start development server
make rebuild-wasm       # Rebuild WASM module
make shell              # Open shell in Rust container

# Testing
make test               # Run all tests
make test-rust          # Run Rust tests only
make test-wasm          # Run WASM tests only

# Production
make prod               # Start production server

# Utilities
make build              # Build all images
make clean              # Clean up containers/images
make help               # Show all commands
```

## Testing

**Docker testing:**
```bash
make test               # Run all tests in container
make test-rust          # Rust tests only
make test-wasm          # WASM tests only
```

**Local testing:**
```bash
cargo test                              # Rust tests
wasm-pack test --headless --firefox     # WASM tests
```

## Implementation Tasks

### Phase 1: FFT Foundation
- [ ] Implement basic FFT using `rustfft`
- [ ] Write tests with known sine waves
- [ ] Set up audio input in JavaScript

### Phase 2: Audio Analysis  
- [ ] Real-time spectrogram visualization
- [ ] Fundamental frequency detection
- [ ] Harmonic detection and filtering

### Phase 3: Dissonance Analysis
- [ ] Implement dissonance calculation model
- [ ] Visualize dissonance curves
- [ ] Test with various frequency pairs

### Phase 4: Scale Design
- [ ] Optimal scale generation algorithm
- [ ] Scale comparison tools
- [ ] Custom tuning system

### Phase 5: Instrument Design
- [ ] Reverse engineering for optimal fret positions
- [ ] Custom tuner for new instrument
- [ ] Audio synthesis for testing

## Resources

- [Rust WASM Book](https://rustwasm.github.io/docs/book/)
- [rustfft Documentation](https://docs.rs/rustfft/)
- [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API) harmonic-analyzer
