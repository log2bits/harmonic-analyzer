# Multi-stage build for Rust + WASM + Web serving

# Stage 1: Build the WASM module
FROM rust:1.75 as wasm-builder

# Install wasm-pack
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

# Set working directory
WORKDIR /app

# Copy Rust source files
COPY Cargo.toml Cargo.lock ./
COPY src/ ./src/
COPY tests/ ./tests/

# Build WASM module
RUN wasm-pack build --target web --out-dir www/pkg

# Stage 2: Development environment
FROM node:18-alpine as development

# Install Python for simple HTTP server (alternative to Node server)
RUN apk add --no-cache python3

WORKDIR /app

# Copy web files and built WASM
COPY www/ ./www/
COPY --from=wasm-builder /app/www/pkg ./www/pkg

# Expose port
EXPOSE 8000

# Default command for development
CMD ["python3", "-m", "http.server", "8000", "--directory", "www"]

# Stage 3: Production build
FROM nginx:alpine as production

# Copy web files and WASM build
COPY www/ /usr/share/nginx/html/
COPY --from=wasm-builder /app/www/pkg /usr/share/nginx/html/pkg

# Copy nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
