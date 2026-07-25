# AGENTS.md

Guidance for AI coding agents (and humans) working in this repository.

## What this is

A personal Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim) and [flake-parts](https://flake.parts). Three profiles share a common base of editing primitives, options, and keymaps:

| Profile | Flake output | Purpose |
|---------|--------------|---------|
| **NixVim** | `.#NixVim` | Full-featured standalone Neovim — LSP, pickers, git, DAP, AI, dbt/Snowflake workflow |
| **CodeVim** | `.#CodeVim` | Lean config for [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) — editing primitives only, LSP/nav delegated to VSCode |
| **LazyVim** | `.#LazyVim` | LazyVim-based stub |

## Repository layout

```
flake.nix              # flake-parts entry — defines perSystem packages, apps, checks, docker images
flake.lock             # pinned nixpkgs-unstable + nixvim
shared/                # Modules imported by every profile
  options.nix          # Base vim options, leader keys, clipboard
  editing.nix          # Core editing plugins (treesitter, flash, surround, …)
  plugins.nix          # Shared plugins (gitsigns, grug-far, persistence, …)
  keymaps.nix           # Shared keymaps (diagnostics, git, format, trouble, …)
nixvim-config/         # Full Neovim profile
  default.nix          # Imports list for the profile
  dependencies.nix     # extraPackages + nixvim `dependencies` (lazygit, ripgrep, snowsql, …)
  options.nix          # nixvim-only opts (tabline, OSC 52 clipboard, snacks indent toggle)
  visual.nix           # Colorscheme (catppuccin/base16), bufferline, lualine, which-key base
  lsp.nix              # LSP servers, blink-cmp, nvim-lint, trouble
  plugins.nix          # nixvim-only plugins (snacks, oil, noice, sidekick, dadbod, …)
  keymaps.nix          # nixvim-only keymaps + which-key group specs
  dap.nix              # nvim-dap, dap-ui, dap-python, dap-go, OSV
  ftplugin/sql.nix     # SQL ftplugin — Jinja-brace highlighting for dbt models
  overseer/            # Overseer task runner config + per-language templates
    overseer.nix       # Registers every *.lua template via readFile
    dbt_tasks.lua      # dbt run/test/compile/build/show/parse/ls/debug + selector variants
    airflow_tasks.lua  # Astro CLI + vanilla Airflow fallback
    python_tasks.lua   # pytest, mypy, ruff format, python run
    ruff_check.lua     # Ruff lint + BufWritePost auto-run
    go_tasks.lua       # go build/test/vet/golangci-lint
    lua_tasks.lua
    nix_tasks.lua      # alejandra, statix, deadnix, nix flake check, nix build
codevim-config/        # VSCode-embedded profile
  default.nix lsp.nix plugins.nix keymaps.nix dependencies.nix
lazyvim-config/        # LazyVim stub (work in progress)
docker/                # Helper scripts for docker build/load/run/export/push
KEYBINDS.md            # Reference for non-which-key binds (insert mode, function keys, plugin-internal)
README.md             # User-facing docs
```

## Build, run, validate

```bash
# Validate the whole flake (runs nixvim's test derivation for all 3 profiles)
nix flake check

# Build a single profile
nix build .#NixVim
nix build .#CodeVim

# Build nixvim's own test derivation for the NixVim profile specifically
nix build .#checks.x86_64-linux.NixVim

# Run a profile without installing
nix run .#NixVim
nix run .            # default app is nixvim-wrapper
```

Pre-commit expectations:

- **Format with alejandra**: `alejandra .` (nix files) / `stylua` (lua files) before committing.
- **Lint**: `statix check .` and `deadnix .` will surface issues; both are wired as overseer templates.
- Do **not** commit the `result` symlink — it is gitignored.

## Conventions

### Leader keys
- `mapleader` = `<Space>`
- `maplocalleader` = `\`

### `<leader>` group map (nixvim-config)

The `which-key` spec lives in `nixvim-config/keymaps.nix` (nixvim-specific groups) and `shared/keymaps.nix` (shared groups). The full map:

| Prefix | Group | File |
|--------|-------|------|
| `<leader><leader>` | smart find files | keymaps.nix |
| `<leader>f` | find | keymaps.nix |
| `<leader>s` | search (grep) | keymaps.nix |
| `<leader>g` | git | shared/keymaps.nix |
| `<leader>gh` | hunk | shared/keymaps.nix |
| `<leader>gl` | line | shared/keymaps.nix |
| `<leader>c` | code | shared/keymaps.nix |
| `<leader>cf` | format | shared/keymaps.nix |
| `<leader>ct` | treesitter | shared/keymaps.nix |
| `<leader>r` | find and replace | shared/keymaps.nix |
| `<leader>x` | trouble | shared/keymaps.nix |
| `<leader>q` | session | shared/keymaps.nix |
| `<leader>u` | ui | keymaps.nix |
| `<leader>um` | markdown | keymaps.nix |
| `<leader>ut` | treesitter | keymaps.nix |
| `<leader>t` | tabs | keymaps.nix |
| `<leader>T` | test (neotest) | keymaps.nix |
| `<leader>O` | obsidian | keymaps.nix |
| `<leader>a` | opencode | keymaps.nix |
| `<leader>k` | sidekick (AI CLI terminal) | keymaps.nix |
| `<leader>N` | nix-develop | keymaps.nix |
| `<leader>Q` | database (dadbod-ui + dbee) | keymaps.nix |
| `<leader>X` | betterTerm send-to-terminal | keymaps.nix |
| `<leader>d` | debug (DAP) | keymaps.nix |
| `<leader>h` | harpoon | keymaps.nix |
| `<leader>n` | notifications history (single-key) | shared/keymaps.nix |
| `<leader>O` | obsidian (single-key opens Obsidian) | keymaps.nix |

### Non-`<leader>` keys (documented in KEYBINDS.md)
- `gd/gD/gr/gI/gy` — LSP navigation via Snacks picker
- `[d/]d/[e/]e` — diagnostic navigation
- `[h/]h` — git hunk navigation
- `[T/]T` — neotest failed-test navigation
- `{/}` — Aerial symbol navigation
- `<S-h>/<S-l>` — bufferline tab cycling
- `<M-h/j/k/l>` — tmux pane navigation
- `<C-\>` — snacks.terminal toggle (normal + terminal mode)
- `<C-\\>` — betterTerm toggle / new tab
- `<F5>/<F10>/<F11>/<F12>` — DAP continue/over/into/out

### Lazy loading
- Most plugins are gated with `lazyLoad.settings.event = ["BufEnter"]` (per-buffer load).
- Heavy/optional plugins gate on a command: `lazyLoad.settings.cmd = "..."`.
- LLM/AI plugins gate on `["VimEnter"]` so they don't block initial UI.
- `otter` gates on `BufReadPost` for `md,sql,jinja,quarto,ipynb` (embedded languages). The nixvim module's `autoActivate` is **disabled** (its global LspAttach hook would `require('otter')` on every LSP attach and throw on non-matching buffers that haven't lazy-loaded). A guarded, `pcall`-protected `LspAttach` autocmd (in `plugins.nix` `extraConfigLua`) replaces it.
- Plugins built from source via `buildVimPlugin` (in `nixvim-config/extra-plugins.nix`): `betterTerm.nvim` (CRAG666). `vim-dadbod` ships its own `snowflake://` adapter (no `vim-dadbod-snowflake` fork needed).
- `nix-develop` gates on `BufReadPost *.nix`.

### When adding a new plugin
1. Verify it exists as a nixvim by-name module: `plugins/by-name/<name>/default.nix` at the pinned nixvim rev (see `flake.lock` → `nodes.nixvim.locked.rev`).
2. If present: configure via `plugins.<name>.enable = true;` + `settings = {...};` + `lazyLoad` if heavy.
3. If absent (e.g. `betterTerm.nvim`, `vim-dadbod-snowflake`): build from source in `nixvim-config/extra-plugins.nix` using `pkgs.vimUtils.buildVimPlugin { pname = "..."; src = pkgs.fetchFromGitHub {...}; }`.
4. Register any user commands → keymaps in `keymaps.nix`, and the which-key group in the same file.
5. Update this `<leader>` group map table and `KEYBINDS.md` if the bind isn't visible in which-key.
6. Run `nix flake check` and `nix build .#NixVim`.

## dbt + Snowflake workflow

### Run / compile / preview dbt models
All dbt operations are surfaced as **overseer templates** (`nixvim-config/overseer/dbt_tasks.lua`). Templates only register when `dbt` is on `PATH`. Run via `<leader>Or` (OverseerRun) and pick from the list:

- `dbt run` / `dbt run (current model)` — build, output in bottom split
- `dbt build` / `dbt build (current model)` — run + test + seed in one
- `dbt test` / `dbt test (current model)`
- `dbt compile (with preview)` — compiles, opens `target/compiled/…/<model>.sql` in a vertical split, read-only. **This is the killer template** — review the expanded Jinja, copy/paste to run in dadbod-ui.
- `dbt show` — inline preview without materialising
- `dbt parse` / `dbt ls` — fast pre-flight checks (no DB connection, ~1s)
- `dbt debug` — connection troubleshooting
- Selector variants: `dbt run --select +<model>` (with parents), `dbt run --select <model>+` (with children), `dbt run --select state:modified` (slim CI — requires `--state`), `dbt run --select tag:<N>`
- `dbt seed` / `dbt snapshot` / `dbt deps` / `dbt docs generate`

Output goes to a split via the `open_output` component (overseer's own rendering — does **not** use snacks.terminal or betterTerm).

### Airflow
`overseer/airflow_tasks.lua` provides Astro CLI templates when `astro` is on PATH:
- `astro dev parse` — DAG parse validation
- `astro dev test <dag>` — pytest the dag
- `astro dev run <dag> <task> <date>` — run a task instance

Plus fallback `airflow dags test` / `airflow tasks test` templates that only register when `astro` is absent but `airflow` is present.

### Send to a persistent terminal
For interactive dbt/Snowflake shells (`snowsql`, a venv REPL, an `astro dev` shell), use **betterTerm**:
- `<C-\\>` — toggle/open a new betterTerm tab
- `<leader>X1..5` — focus terminal 1–5
- `<leader>Xs` — send current line to the current terminal
- `<leader>Xv` — send visual selection (visual mode)
- `<leader>Xf` — send the whole file
- `<leader>Xr` — rename the current terminal
- `<leader>Xk` — kill the current terminal

### Querying Snowflake directly
Two complementary clients are wired up; both lazy-load on `cmd`:

1. **vim-dadbod + vim-dadbod-ui + vim-dadbod-snowflake** — `<leader>Qo` opens the `:DBUI` drawer. Connections are stored per-project in a gitignored `.local/dbui.json` (or `~/.local/share/nvim/dadbod-ui/` for global). Edit the connection list with `<leader>Qe`. Open a SQL scratch buffer, `:DBUIEditConnections`, then `:w` on a query buffer to execute. Results render in a dadbod results buffer.
2. **dbee** — `<leader>Qd` toggles dbee's own UI browser; better for ad-hoc exploration.

`snowsql` is in `extraPackages`; `snowflake-connector-python` is added when it builds cleanly on the pinned nixpkgs.

### Aerial / sqls inside dbt models
- `filetype` stays `sql` on dbt `.sql` models (so `sqls` LSP works), with a small `ftplugin/sql.nix` adding Jinja-brace highlighting only (see below).
- `otter` (lazy `BufReadPost` for `md,sql,jinja,quarto,ipynb`) handles embedded-language LSP — e.g. SQL blocks inside markdown or `.sql.jinja` files.

### opt-in: sqls + Snowflake catalog completion
`sqls` is already enabled in `lsp.nix`. To get in-editor schema/table/column completion on dbt `.sql` models, create `~/.config/sqls/config.yml`:

```yaml
connections:
  - alias: snowflake-prod
    driver: snowflake
    dataSourceName: "user:password@account/database/schema?warehouse=WH&role=ROLE"
```

Then restart Neovim. No flake changes required — purely an opt-in per-user config. The blink-cmp `dadbod` source also provides completion inside dadbod-ui query buffers.

## Docker

Self-contained Docker images via `dockerTools.buildImage` (entrypoint `/bin/nvim`). Three helper scripts in `docker/`:

```bash
./docker/docker-run-registry.sh [PROFILE] [--] [NVIM_ARGS...]   # Docker Hub (no Nix needed)
./docker/docker-run.sh [PROFILE] [--] [NVIM_ARGS...]            # local Nix build fallback
./docker/docker-export.sh [PROFILE]                             # portable tar.gz
./docker/docker-push.sh [PROFILE]                                # maintainer push to Docker Hub
```

See README.md for full details.

## Things to avoid

- Do **not** enable `copilot-lsp` — sidekick NES is intentionally disabled (CLI-terminal mode only).
- Do **not** wire `copilot-lua` completion — Avante and sidekick own the AI surface; copilot-lua is disabled.
- Do **not** introduce `telescope.nvim` / `plenary.nvim` standalone dbt plugins (`dbt.nvim`, `dbtpal`) — overseer + dadbod + snacks picker cover the workflow and bit-rot less.
- Do **not** enable `none-ls` — the block is intentionally removed in favour of `nvim-lint` + `conform-nvim`.
- Do **not** split `keymaps.nix` into per-area files without a follow-up; it's a single 1400-line file by choice.

## Pinned versions (relevant to plugin availability)

From `flake.lock`:
- `nixvim` rev: `f316e949e0ed9df0e1e0bf645c6dce721d4e230e`
- `nixpkgs`: `nixpkgs-unstable` (rev `7525d999cd850b9a488817abc89c75dc733acf17`)

Available as nixvim by-name modules at this rev: `sidekick`, `opencode`, `otter`, `nix-develop`, `vim-dadbod`, `vim-dadbod-ui`, `dbee`, `copilot-lsp`, `blink-compat`.

**Not** as nixvim modules (built from source in `extra-plugins.nix`): `betterTerm.nvim` (CRAG666).
`snowsql` is in `extraPackages` and `vim-dadbod`'s built-in `snowflake://` adapter shells out to it (no `vim-dadbod-snowflake` fork needed).