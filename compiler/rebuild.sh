#!/usr/bin/bash
cargo run main.ha && ./main main.ha -r && ./main main.ha -r
mkdir -p $HOME/.local/lib/halppp
cp ../lib/*.ha $HOME/.local/lib/halppp

