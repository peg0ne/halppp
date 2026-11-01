#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
LIB_DIR="${HALPPP_LIB:-$HOME/.local/lib/halppp}"
mkdir -p "$LIB_DIR"
cp -r ../lib/* "$LIB_DIR"
