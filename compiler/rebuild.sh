#!/usr/bin/env bash
# Linux / macOS: bootstrap with the Rust compiler, then let halppp rebuild itself.
# Set HALPPP_CXX (or CXX) to choose the C++ compiler, HALPPP_LIB for the library folder.
set -e
cd "$(dirname "$0")"
cargo run -- main.ha
./main main.ha -r
./main main.ha -r
LIB_DIR="${HALPPP_LIB:-$HOME/.local/lib/halppp}"
mkdir -p "$LIB_DIR"
cp -r ../lib/* "$LIB_DIR"
