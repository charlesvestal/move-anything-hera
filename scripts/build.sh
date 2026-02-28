#!/usr/bin/env bash
# Build Hera module for Move Anything (ARM64)
#
# Automatically uses Docker for cross-compilation if needed.
# Set CROSS_PREFIX to skip Docker (e.g., for native ARM builds).
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
IMAGE_NAME="move-anything-builder"

# Check if we need Docker
if [ -z "$CROSS_PREFIX" ] && [ ! -f "/.dockerenv" ]; then
    echo "=== Hera Module Build (via Docker) ==="
    echo ""

    # Build Docker image if needed
    if ! docker image inspect "$IMAGE_NAME" &>/dev/null; then
        echo "Building Docker image (first time only)..."
        docker build -t "$IMAGE_NAME" -f "$SCRIPT_DIR/Dockerfile" "$REPO_ROOT"
        echo ""
    fi

    # Run build inside container
    echo "Running build..."
    docker run --rm \
        -v "$REPO_ROOT:/build" \
        -u "$(id -u):$(id -g)" \
        -w /build \
        "$IMAGE_NAME" \
        ./scripts/build.sh

    echo ""
    echo "=== Done ==="
    exit 0
fi

# === Actual build (runs in Docker or with cross-compiler) ===
CROSS_PREFIX="${CROSS_PREFIX:-aarch64-linux-gnu-}"

cd "$REPO_ROOT"

echo "=== Building Hera Module ==="
echo "Cross prefix: $CROSS_PREFIX"

# Create build directories
mkdir -p build
mkdir -p dist/hera

# Compile DSP plugin
echo "Compiling DSP plugin..."
${CROSS_PREFIX}g++ -g -O3 -shared -fPIC -std=c++14 \
    src/dsp/hera_plugin.cpp \
    src/dsp/Engine/HeraEnvelope.cpp \
    src/dsp/Engine/HeraLFO.cpp \
    src/dsp/Engine/HeraLFOWithEnvelope.cpp \
    src/dsp/Engine/HeraTables.cpp \
    src/dsp/Engine/bbd_line.cpp \
    src/dsp/Engine/bbd_filter.cpp \
    -o build/dsp.so \
    -Isrc/dsp \
    -Isrc/dsp/Engine \
    -lm

# Copy files to dist (use cat to avoid ExtFS deallocation issues with Docker)
echo "Packaging..."
cat src/module.json > dist/hera/module.json
[ -f src/help.json ] && cat src/help.json > dist/hera/help.json
cat src/ui.js > dist/hera/ui.js
cat build/dsp.so > dist/hera/dsp.so
chmod +x dist/hera/dsp.so

# Copy presets
if [ -d "src/presets" ]; then
    mkdir -p dist/hera/presets
    for f in src/presets/*.xml; do
        cat "$f" > "dist/hera/presets/$(basename "$f")"
    done
fi

# Create tarball for release
cd dist
tar -czvf hera-module.tar.gz hera/
cd ..

echo ""
echo "=== Build Complete ==="
echo "Output: dist/hera/"
echo "Tarball: dist/hera-module.tar.gz"
echo ""
echo "To install on Move:"
echo "  ./scripts/install.sh"
