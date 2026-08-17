# AGENTS.md

Guidance for AI coding agents (and humans) working in this repository.

## What this is

A personal Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim) and [flake-parts](https://flake.parts). Three profiles share a common base of editing primitives, options, and keymaps:

| Profile | Flake output | Purpose |
|---------|--------------|---------|
| **NixVim** | `.#NixVim` | Full-featured standalone Neovim — LSP, pickers, git, DAP, AI, dbt + Snowflake CLI workflow |
| **CodeVim** | `.#CodeVim` | Lean config for [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) — editing primitives only, LSP/nav delegated to VSCode |
| **LazyVim** | `.#LazyVim` | LazyVim-based stub |

## Documentation sources

- Official nixvim documentation with configuration and plugin options is available at https://nix-community.github.io/nixvim/index.html
- Some neovim plugins might be not officialy supported by nixvim options but still available on nixpkgs under vimPlugins prefix

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
  dependencies.nix     # extraPackages + nixvim `dependencies` (lazygit, ripgrep, snowflakeCli, …)
  options.nix          # nixvim-only opts (tabline, OSC 52 clipboard, snacks indent toggle)
  visual.nix           # Colorscheme (catppuccin/base16), bufferline, lualine, which-key base
  lsp.nix              # LSP servers, blink-cmp, nvim-lint, trouble
  plugins.nix          # nixvim-only plugins (snacks, oil, noice, opencode, sidekick, dbee, …)
  keymaps.nix          # nixvim-only keymaps + which-key group specs
  dap.nix              # nvim-dap, dap-ui, dap-python, dap-go, OSV
  # SQL ftplugin (Jinja-brace highlighting for dbt models) is an extraFiles
  # entry `ftplugin/sql.lua` inside plugins.nix — there is no ftplugin/ dir.
  overseer/            # Overseer task runner config + per-language templates
    overseer.nix         # Registers every *.lua template via readFile
    dbt_tasks.lua        # dbt run/test/compile/build/show/parse/ls/debug + selector variants
    snowflake_tasks.lua  # `snow` CLI: describe/list/connection test + confirm-gated run
    airflow_tasks.lua    # Astro CLI + vanilla Airflow fallback
    python_tasks.lua     # pytest, mypy, ruff format, python run
    ruff_check.lua       # Ruff lint + BufWritePost auto-run
    go_tasks.lua         # go build/test/vet/golangci-lint
    lua_tasks.lua
    nix_tasks.lua        # alejandra, statix, deadnix, nix flake check, nix build
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
| `<leader>C` | config dashboard (agents backend) | keymaps.nix |
| `<leader>r` | find and replace | shared/keymaps.nix |
| `<leader>x` | trouble | shared/keymaps.nix |
| `<leader>q` | session | shared/keymaps.nix |
| `<leader>u` | ui | keymaps.nix |
| `<leader>um` | markdown | keymaps.nix |
| `<leader>ut` | treesitter | keymaps.nix |
| `<leader>t` | tabs | keymaps.nix |
| `<leader>T` | test (neotest) | keymaps.nix |
| `<leader><tab>` | agents (sidekick / herd) | keymaps.nix |
| `<leader>o` | opencode | keymaps.nix |
| `<S-Space>` | window picker | keymaps.nix |
| `<leader>O` | obsidian | keymaps.nix |
| `<leader>N` | nix-develop | keymaps.nix |
| `<leader>Q` | database (dbee + Snowflake CLI overseer templates) | keymaps.nix |
| `<leader>X` | betterTerm send-to-terminal | keymaps.nix |
| `<leader>d` | debug (DAP) | keymaps.nix |
| `<leader>h` | harpoon | keymaps.nix |
| `<leader>w` | window (picker) | keymaps.nix |
| `<leader>n` | notifications history (single-key) | shared/keymaps.nix |
| `<leader>O` | obsidian (single-key opens Obsidian) | keymaps.nix |

### Non-`<leader>` keys (documented in KEYBINDS.md)
- `gd/gD/gr/gI/gy` — LSP navigation via Snacks picker
- `[d/]d/[e/]e` — diagnostic navigation
- `[h/]h` — git hunk navigation
- `[T/]T` — neotest failed-test navigation
- `{/}` — Aerial symbol navigation
- `<S-h>/<S-l>` — bufferline tab cycling
- `<leader>w` — window-picker (jump to window by big floating letter)
- `<C-w>h/j/k/l` — standard Neovim window navigation (no leader mapping)
- `<C-\>` — snacks.terminal toggle (normal mode only; use `<S-Esc>` in terminal mode to exit)
- `<C-/>` — snacks.terminal float toggle (moved off `<leader>tf`, which collided with "First Tab")
- `<F5>/<F10>/<F11>/<F12>` — DAP continue/over/into/out

### Lazy loading
- Most plugins are gated with `lazyLoad.settings.event = ["BufEnter"]` (per-buffer load).
- Heavy/optional plugins gate on a command: `lazyLoad.settings.cmd = "..."`.
- LLM/AI plugins gate on `["VimEnter"]` so they don't block initial UI.
- `otter` gates on `BufReadPost` for `md,sql,jinja,quarto,ipynb` (embedded languages). The nixvim module's `autoActivate` is **disabled** (its global LspAttach hook would `require('otter')` on every LSP attach and throw on non-matching buffers that haven't lazy-loaded). A guarded, `pcall`-protected `LspAttach` autocmd (in `plugins.nix` `extraConfigLua`) replaces it.
- Plugins built from source via `buildVimPlugin` (in `nixvim-config/extra-plugins.nix`): `betterTerm.nvim` (CRAG666) and `herd.nvim` (MomePP).
- `nix-develop` gates on `BufReadPost *.nix`.

### When adding a new plugin
1. Verify it exists as a nixvim by-name module: `plugins/by-name/<name>/default.nix` at the pinned nixvim rev (see `flake.lock` → `nodes.nixvim.locked.rev`).
2. If present: configure via `plugins.<name>.enable = true;` + `settings = {...};` + `lazyLoad` if heavy.
3. If absent (e.g. `betterTerm.nvim`): build from source in `nixvim-config/extra-plugins.nix` using `pkgs.vimUtils.buildVimPlugin { pname = "..."; src = pkgs.fetchFromGitHub {...}; }`.
4. Register any user commands → keymaps in `keymaps.nix`, and the which-key group in the same file.
5. Update this `<leader>` group map table and `KEYBINDS.md` if the bind isn't visible in which-key.
6. Run `nix flake check` and `nix build .#NixVim`.

## dbt + Snowflake workflow

### Why the Snowflake tooling looks the way it does
`vim-dadbod`'s built-in `snowflake://` adapter shells out to `snowsql`, which nixpkgs only packages for `x86_64-linux` — it fails to evaluate on `aarch64-linux` (e.g. this repo's OrbStack/NixOS target on Apple Silicon). `nvim-dbee` was evaluated as a dadbod replacement but has **no Snowflake driver** (tracked upstream: kndndrj/nvim-dbee#23, unmerged PRs #109/#186) and no CLI-shelling adapter mechanism to bolt one on. So both dadbod and dbee are out for Snowflake specifically. The replacement is the official **Snowflake CLI (`snow`)**, packaged as `snowflake-cli` in nixpkgs, driven through **overseer task templates** and **betterTerm**.

`snowflake-cli` itself has a build wrinkle: at `nixpkgs-unstable`/`nixos-unstable`, its `snowflake-connector-python` dependency fails its test suite on `aarch64-linux` (`test_log_debug_config_file_parent_dir_permissions` assumes the process isn't root; Nix's build sandbox always runs as root, so the test's `chmod`-based permission check never fires and the assertion fails). It builds cleanly — as a cached binary, no compile — on the `nixos-25.05` release channel. `flake.nix` therefore pins a second nixpkgs input, `nixpkgs-snowflake` (`github:nixos/nixpkgs/nixos-25.05`), used **only** to source `snowflake-cli`; everything else in the flake still comes from the main `nixpkgs-unstable` input. See the comment above `nixpkgs-snowflake.url` in `flake.nix`. Revisit/drop this pin once the upstream test is fixed.

### Run / compile / preview dbt models
All dbt operations are surfaced as **overseer templates** (`nixvim-config/overseer/dbt_tasks.lua`). Templates only register when `dbt` is on `PATH`. Run via `<leader>Or` (OverseerRun) and pick from the list:

- `dbt run` / `dbt run (current model)` — build, output in bottom split
- `dbt build` / `dbt build (current model)` — run + test + seed in one
- `dbt test` / `dbt test (current model)`
- `dbt compile (current model) — open compiled SQL` — compiles, opens `target/compiled/…/<model>.sql` in a vertical split, read-only. **This is the killer template** — review the expanded Jinja, then run it against Snowflake with `snowflake: run compiled SQL for current dbt model` (below).
- `dbt show` — inline preview without materialising
- `dbt parse` / `dbt ls` — fast pre-flight checks (no DB connection, ~1s)
- `dbt debug` — connection troubleshooting
- Selector variants: `dbt run --select +<model>` (with parents), `dbt run --select <model>+` (with children), `dbt run --select state:modified` (slim CI — requires `--state`), `dbt run --select tag:<N>`
- `dbt seed` / `dbt snapshot` / `dbt deps` / `dbt docs generate`

Output goes to a split via the `open_output` component (overseer's own rendering — does **not** use snacks.terminal or betterTerm).

### Querying Snowflake — `snow` CLI via overseer (`overseer/snowflake_tasks.lua`)
Templates only register when `snow` is on `PATH`. Connections come from `~/.snowflake/config.toml` (or `$SNOWFLAKE_HOME`) connection profiles — **never** put a password in a template or a keymap; `snow` itself refuses to read a `config.toml` with permissions wider than `0600`.

Reachable via `<leader>Or`/`<leader>Qo` (OverseerRun picker), or directly:

- `<leader>Qr` — run current line (prompts **Run/Cancel** with a preview of the SQL before sending anything)
- `<leader>Qv` (visual mode) — run visual selection (same confirm prompt)
- `<leader>Qt` — connection test
- `snowflake: run compiled SQL for current dbt model` — runs `target/compiled/…/<model>.sql` (the *compiled* file, never the dbt source, since the source still has unexpanded Jinja that `snow sql` can't execute) — also confirm-gated
- `snowflake: describe current table/view (cursor word)`, `list warehouses`, `list databases`, `list tables (prompt database.schema)`, `connection list` — read-only, run unprompted

**Safety model:** every template that executes arbitrary/buffer SQL shows a truncated preview and asks to confirm before running (a dbt `.sql` buffer can contain `DROP`/`DELETE`/`TRUNCATE`/`MERGE`, and overseer has no undo). Read-only templates (`describe`/`list`/`connection test`) skip the prompt. No template runs a whole *project* of SQL files unattended — unlike `dbt run`/`dbt build`, there's no dbt-style DAG/state layer to bound the blast radius of running raw SQL, so batch execution is intentionally not offered.

For a persistent interactive session (not a one-shot query), use **betterTerm** + `snow sql -i`/`snow sql --interactive` rather than an overseer template — overseer's output panes are one-shot, not built for back-and-forth.

### Airflow
`overseer/airflow_tasks.lua` provides Astro CLI templates when `astro` is on PATH:
- `astro dev parse` — DAG parse validation
- `astro dev test <dag>` — pytest the dag
- `astro dev run <dag> <task> <date>` — run a task instance

Plus fallback `airflow dags test` / `airflow tasks test` templates that only register when `astro` is absent but `airflow` is present.

### Send to a persistent terminal
For interactive dbt/`snow sql`/airflow shells, use **betterTerm**:
- `<C-\\>` — toggle/open a new betterTerm tab
- `<leader>X1..5` — focus terminal 1–5
- `<leader>Xs` — send current line to the current terminal
- `<leader>Xv` — send visual selection (visual mode)
- `<leader>Xf` — send the whole file
- `<leader>Xr` — rename the current terminal
- `<leader>Xk` — kill the current terminal

### dbee (non-Snowflake connections)
`dbee` (`<leader>Qd` toggles its UI) is still wired up for ad-hoc exploration of databases it *does* support natively (postgres, mysql, sqlite, duckdb, clickhouse, bigquery, redshift, databricks, oracle, sqlserver, mongo, redis) — just not Snowflake.

### Aerial / sqls inside dbt models
- `filetype` stays `sql` on dbt `.sql` models (so `sqls` LSP works), with a small `ftplugin/sql.lua` (extraFiles in `plugins.nix`) adding Jinja-brace highlighting only (see below).
- `otter` (lazy `BufReadPost` for `md,sql,jinja,quarto,ipynb`) handles embedded-language LSP — e.g. SQL blocks inside markdown or `.sql.jinja` files.

### opt-in: sqls + Snowflake catalog completion
`sqls` is already enabled in `lsp.nix`. To get in-editor schema/table/column completion on dbt `.sql` models, create `~/.config/sqls/config.yml`:

```yaml
connections:
  - alias: snowflake-prod
    driver: snowflake
    dataSourceName: "user:password@account/database/schema?warehouse=WH&role=ROLE"
```

Then restart Neovim. No flake changes required — purely an opt-in per-user config.

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
- Do **not** wire `copilot-lua` completion — Avante and sidekick own the AI surface; `copilot-lua` is disabled.
- Do **not** enable `herd.nvim` default keys — they are disabled in `extra-plugins.nix` because they would shadow the `<leader>s` search group and `<leader>o` opencode group; keep them off and use the `<leader><tab>` bindings installed by `lua/agent_backend.lua` instead.
- Do **not** introduce `telescope.nvim` / `plenary.nvim` standalone dbt plugins (`dbt.nvim`, `dbtpal`) — overseer + snacks picker cover the workflow and bit-rot less.
- Do **not** re-add `vim-dadbod`/`vim-dadbod-ui`/`snowsql` for Snowflake — `snowsql` is unsupported on `aarch64-linux` (see "Why the Snowflake tooling looks the way it does" above). `nvim-dbee` is not a substitute either — it has no Snowflake driver.
- Do **not** add a `--password`/credential flag to any Snowflake overseer template or keymap — connections must come from `~/.snowflake/config.toml` connection profiles.
- Do **not** enable `none-ls` — the block is intentionally removed in favour of `nvim-lint` + `conform-nvim`.
- Do **not** split `keymaps.nix` into per-area files without a follow-up; it's a single 1400-line file by choice.

## Pinned versions (relevant to plugin availability)

From `flake.lock`:
- `nixvim` rev: `f316e949e0ed9df0e1e0bf645c6dce721d4e230e`
- `nixpkgs`: `nixpkgs-unstable` (rev `7525d999cd850b9a488817abc89c75dc733acf17`)
- `nixpkgs-snowflake`: `nixos-25.05` — feeds **only** `snowflake-cli` (see "Why the Snowflake tooling looks the way it does" above); everything else still comes from `nixpkgs` above.

Available as nixvim by-name modules at this rev: `sidekick`, `otter`, `nix-develop`, `dbee`, `copilot-lsp`, `blink-compat`.

**Not** as nixvim modules (built from source): `betterTerm.nvim` (CRAG666, `extra-plugins.nix`), `herd.nvim` (MomePP, `extra-plugins.nix`), and **`opencode.nvim`** (sudo-tee, pinned in `extra-plugins.nix`, loaded via `plugins.lz-n.plugins` in `plugins.nix`). Note: nixpkgs' `vimPlugins.opencode-nvim` tracks **nickjvandyke/opencode.nvim** — the fork that keeps the legacy `vim.g.opencode_opts` / `require("opencode").{ask,select,operator,statusline}` API — so that API was *not* removed upstream. We deliberately pin sudo-tee's main instead for the new unified `:Opencode` command API (`require("opencode.api").<action>`) and its richer features (quick chat, diff view, snapshots, MCP picker, skills browser). Bump deliberately — the `<leader>o` keymaps in `keymaps.nix` call that API.
`snowflakeCli` (from the `nixpkgs-snowflake` input, see `flake.nix`) is passed into `nixvim-config` via `extraSpecialArgs` and added to `extraPackages` in `dependencies.nix`.
