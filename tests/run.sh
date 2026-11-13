#!/usr/bin/env bash
# Builds every tests/*.ha with both the single-file (-s) and the incremental build,
# runs it and, when tests/expected/<name>.out exists, compares its output to that file.
# Usage: tests/run.sh [path/to/halppp] [test-name...]
# Set UPDATE=1 to (re)write the expected files from the incremental build's output.
cd "$(dirname "$0")" || exit 1
HALPPP="${1:-../compiler/main}"
case "$HALPPP" in /*) ;; *) HALPPP="$PWD/$HALPPP" ;; esac
shift
export HALPPP_LIB="${HALPPP_LIB:-$PWD/../lib/}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p expected

tests=("$@")
if [ ${#tests[@]} -eq 0 ]; then
    for f in *.ha; do tests+=("${f%.ha}"); done
fi

failed=0
for name in "${tests[@]}"; do
    for mode in single incremental; do
        flag=""
        [ "$mode" = single ] && flag="-s"
        rm -f "$name" "$name.exe"
        if ! "$HALPPP" "$name.ha" $flag > "$WORK/build.log" 2>&1 || [ ! -x "$name" ]; then
            echo "FAIL $name ($mode): build failed"
            grep -E "error|Error" "$WORK/build.log" | head -10
            failed=$((failed + 1))
            continue
        fi
        # A non-zero exit code is part of the output, so expected files can check it
        ./"$name" > "$WORK/out.txt" 2>&1
        code=$?
        [ $code -ne 0 ] && echo "[exit $code]" >> "$WORK/out.txt"
        if [ $code -ge 128 ]; then
            echo "FAIL $name ($mode): crashed with $code"
            failed=$((failed + 1))
        elif [ "$UPDATE" = 1 ] && [ "$mode" = incremental ]; then
            cp "$WORK/out.txt" "expected/$name.out"
            echo "UPDATED $name"
        elif [ -f "expected/$name.out" ] && ! diff -u "expected/$name.out" "$WORK/out.txt" > "$WORK/diff.txt"; then
            echo "FAIL $name ($mode): output differs"
            head -20 "$WORK/diff.txt"
            failed=$((failed + 1))
        else
            echo "ok   $name ($mode)"
        fi
    done
    rm -f "$name" "$name.exe" "$name.cpp"
done

if [ $failed -ne 0 ]; then
    echo "$failed failure(s)"
    exit 1
fi
echo "all tests passed"
