#!/usr/bin/env bash
# Headless smoke tests for the nixvim-config session changes.#
# Usage:
#   tests/run.sh                 # build .#NixVim and run the suite
#   tests/run.sh /path/to/nvim   # run against an existing nvim binary
#
# Runs four suites:
#   1. tests/headless-smoke.lua  — targeted behaviour checks, incl. the
#      real-load assertion that would have caught the codecompanion
#      `extensions.history` bug (it never calls setup()).
#   2. tests/plugin-sweep.lua    — broad/shallow: every packaged plugin is
#      loadable, every declared keymap exists, <leader>a*/<leader>h* ownership.
#      ⚠️ require()-only: it NEVER calls setup(), so it is a plugin-load gate,
#      NOT proof that the config comes up clean. See the header of that file.
#   3. tests/host-tool.lua      — isolated native/OrbStack tool resolution,
#      explicit executable overrides, and SQL cancellation boundaries.
#   4. tests/post-startup.lua   — state that only exists after the real
#      VimEnter (noice/hardtime config, post-startup :messages).
#
# Exits non-zero when any check fails. Each suite ends itself (qa!/cquit);
# the trailing `-c "cquit 2"` only runs if a suite died on a Lua error, which
# would otherwise leave headless nvim waiting at a prompt forever.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ $# -ge 1 ]]; then
  NVIM="$1"
else
  NVIM="$(nix build .#NixVim --print-out-paths --no-link)/bin/nvim"
fi

echo "── smoke suite ─────────────────────────────────────────────────────"
"$NVIM" --headless -c "luafile tests/headless-smoke.lua" -c "cquit 2"

echo
echo "── plugin/keymap sweep ─────────────────────────────────────────────"
# Expected keymaps are extracted from the nix sources (they are the source of
# truth). Nix string escapes must be undone: `\"` -> `"` and `\\` -> `\`, so
# keys like "<C-\\>" and "<leader>s\"" compare equal to what nvim reports.
# Both cases bit an earlier, hand-rolled version of this extraction.
EXPECTED="$(mktemp)"
trap 'rm -f "$EXPECTED"' EXIT
awk '
  /^[[:space:]]*key = "/ {
    k = $0
    sub(/^[[:space:]]*key = "/, "", k)
    sub(/";[[:space:]]*$/, "", k)
    gsub(/\\"/, "\"", k)
    gsub(/\\\\/, "\\", k)
    pending = k
    next
  }
  /^[[:space:]]*mode = \[/ && pending != "" {
    m = $0
    sub(/.*mode = \[/, "", m)
    sub(/\].*/, "", m)
    gsub(/"/, "", m)
    gsub(/ /, "", m)
    print pending "\t" m
    pending = ""
  }
' nixvim-config/keymaps.nix shared/keymaps.nix > "$EXPECTED"

echo "expected keymaps extracted: $(wc -l < "$EXPECTED")"

# Ex commands invoked by keymaps (`<cmd>Foo`, `<cmd>:Foo`, `":Foo<cr>"`), so
# the post-startup suite can assert each one exists. Count/range-prefixed forms such as
# `<cmd>1tabnext` / `<cmd>-tabmove` start with a non-letter and are skipped.
CMDS="$(mktemp)"
trap 'rm -f "$EXPECTED" "$CMDS"' EXIT
grep -ohE '<cmd>:?[A-Za-z][A-Za-z0-9]*|action = ":[A-Za-z][A-Za-z0-9]*' \
  nixvim-config/keymaps.nix shared/keymaps.nix |
  sed -E 's/^(<cmd>:?|action = ":)//' | sort -u > "$CMDS"
echo "keymap commands extracted: $(wc -l < "$CMDS")"

SWEEP_EXPECTED="$EXPECTED" "$NVIM" --headless -c "luafile tests/plugin-sweep.lua" -c "cquit 2"

echo
echo "── native/OrbStack tool resolution ──────────────────────────────────"
"$NVIM" --headless -c "luafile tests/host-tool.lua" -c "cquit 2"

echo
echo "── post-startup state (after the real VimEnter) ─────────────────────"
# No trailing `cquit 2` here: this suite deliberately returns to the event
# loop so its checks run after VimEnter. `timeout` guards against a hang.
POST_CMDS="$CMDS" timeout 60 "$NVIM" --headless -c "luafile tests/post-startup.lua"
