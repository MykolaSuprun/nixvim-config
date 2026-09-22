#!/usr/bin/env bash
# Headless smoke tests for the nixvim-config session changes.
#
# Usage:
#   tests/run.sh                 # build .#NixVim and run the suite
#   tests/run.sh /path/to/nvim   # run against an existing nvim binary
#
# Exits non-zero when any check fails.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ $# -ge 1 ]]; then
  NVIM="$1"
else
  NVIM="$(nix build .#NixVim --print-out-paths --no-link)/bin/nvim"
fi

exec "$NVIM" --headless -c "luafile tests/headless-smoke.lua"