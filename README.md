# nixvim-config

Personal Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim) and [flake-parts](https://flake.parts). Supports multiple profiles sharing a common base.

## Configurations

| Name | Description |
|------|-------------|
| **NixVim** | Full-featured standalone Neovim — LSP, pickers, git tools, UI, AI |
| **CodeVim** | Lean config for [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim) — editing primitives only, LSP/nav delegated to VSCode |
| **LazyVim** | Stub / work-in-progress |

## Directory Structure

```
shared/           # Modules imported by all configs
  options.nix     # Base vim options, leader keys, clipboard
  editing.nix     # Core editing plugins (treesitter, flash, surround, …)
  plugins.nix     # Shared plugins (gitsigns, grug-far, persistence, …)
  keymaps.nix     # Shared keymaps (diagnostics, git, format, trouble, …)

nixvim-config/    # Full Neovim profile
  lsp.nix         # LSP servers, blink-cmp, nvim-lint, trouble
  plugins.nix     # nixvim-only plugins (snacks, noice, oil, sidekick, dbee, …)
  extra-plugins.nix  # plugins built from source (betterTerm.nvim)
  keymaps.nix     # nixvim-only keymaps + which-key groups (pickers, tabs, dbt, opencode, …)
  visual.nix      # Colorscheme and visual options
  dap.nix         # DAP (nvim-dap, dap-ui, dap-python, dap-go, OSV)
  overseer/       # Overseer task runner config + per-language templates
    dbt_tasks.lua       # dbt run/build/test/compile(+preview)/show/parse/ls/debug + selectors
    snowflake_tasks.lua # `snow` CLI: describe/list/connection test + confirm-gated run
    airflow_tasks.lua   # Astro CLI + vanilla Airflow fallback
    python_tasks.lua    # pytest, mypy, ruff format, python run
    go_tasks.lua / lua_tasks.lua / nix_tasks.lua / ruff_check.lua

See [AGENTS.md](AGENTS.md) for a full directory map, build/validate commands, the
`<leader>` group reference, the dbt + Snowflake workflow docs, and guidelines for
adding new plugins.

codevim-config/   # VSCode-embedded profile
  lsp.nix         # Minimal LSP (no servers — VSCode owns that)
  plugins.nix     # which-key, snacks, conform, trouble
  keymaps.nix     # VSCode delegation keymaps only

lazyvim-config/   # Stub
```

## Usage

Run the full Neovim configuration:
```bash
nix run .
# or explicitly:
nix run .#NixVim
```

Run the VSCode-embedded configuration (intended for `vscode-neovim`):
```bash
nix run .#CodeVim
```

Build without running:
```bash
nix build .#NixVim
nix build .#CodeVim
```

## Validation

```bash
nix flake check
# or per-config:
nix build .#checks.x86_64-linux.NixVim
nix build .#checks.x86_64-linux.CodeVim
```

## Docker Images

Self-contained Docker images are built with Nix's `dockerTools.buildImage`. This produces a minimal, layered image that can be built once on a machine with Nix and then loaded onto any machine with Docker — no Nix installation or network access required on the target. This is ideal for corporate environments with custom certificates or restricted network access.

Three images are available:

| Image | Flake target | Description |
|-------|-------------|-------------|
| `nixvim` | `.#docker-nixvim` | Full Neovim configuration |
| `lazyvim` | `.#docker-lazyvim` | LazyVim-based configuration |
| `codevim` | `.#docker-codevim` | VSCode-embedded Neovim |

### Quick Start (recommended)

Three helper scripts in `docker/` handle build, load, and run.

```bash
# Run from Docker Hub (no Nix required). Auto-detects colima or docker.
./docker/docker-run-registry.sh [PROFILE] [--] [NVIM_ARGS...]

# Run with local Nix build fallback (builds if Docker Hub is offline)
./docker/docker-run.sh [PROFILE] [--] [NVIM_ARGS...]

# Export a portable tarball for offline transfer
./docker/docker-export.sh [PROFILE]

# Build and push to Docker Hub (for maintainers)
./docker/docker-push.sh [PROFILE]
```

#### `docker-run-registry.sh` — Docker Hub only, no Nix

Use this on machines without Nix installed. It pulls directly from Docker Hub and auto-detects `colima` or `docker` as the runtime.

```bash
# Open current directory in nixvim (default profile)
./docker/docker-run-registry.sh

# Open a specific file
./docker/docker-run-registry.sh src/main.rs

# Use a different profile
./docker/docker-run-registry.sh lazyvim -- .
./docker/docker-run-registry.sh codevim -- src/main.rs

# Pass nvim flags
./docker/docker-run-registry.sh -- +"Telescope find_files"
./docker/docker-run-registry.sh nixvim -- --headless -c "echo 'hello' | q"
```

What the script does automatically:
- **Auto-detects container runtime** — prefers `colima` if installed, falls back to `docker`. Override with `DOCKER_CMD=podman`.
- **Starts colima automatically** if it's installed but not running.
- **Pulls from Docker Hub** — `mykolasuprun/nixvim:<profile>-latest`.
- Mounts `$PWD` → `/workspace`.
- Forwards `TERM`, `COLORTERM`, `BAT_THEME`, `STYLIX_COLORSCHEME`, `TMUX`, `TMUX_PANE`.
- Mounts `~/.gitconfig` and `~/.ssh` (read-only) when they exist.
- Auto-detects tmux and forwards the tmux socket when inside tmux.

#### `docker-export.sh`

```bash
# Export nixvim (default) as a gzipped tarball
./docker/docker-export.sh

# Export a specific profile
./docker/docker-export.sh lazyvim
```

Transfer to another machine (no Nix needed on the target):

```bash
scp nixvim-docker.tar.gz target:/tmp
ssh target 'gunzip < /tmp/nixvim-docker.tar.gz | docker load'
ssh target 'docker run --rm -it nixvim:latest'
```

#### `docker-push.sh` (for maintainers)

```bash
# Push nixvim (default) to Docker Hub
./docker/docker-push.sh

# Push a specific profile
./docker/docker-push.sh lazyvim
./docker/docker-push.sh codevim
```

Prerequisites: `docker login -u mykolasuprun`

Pushes to: `mykolasuprun/nixvim:<profile>-latest`

### Using Docker Hub directly

If you prefer to use `docker` commands directly:

```bash
# Pull and run from Docker Hub
docker pull mykolasuprun/nixvim:nixvim-latest
docker run --rm -it mykolasuprun/nixvim:nixvim-latest

# With a host directory mounted
docker run --rm -it -v "$(pwd)":/workspace -w /workspace mykolasuprun/nixvim:nixvim-latest .

# LazyVim
docker run --rm -it -v "$(pwd)":/workspace -w /workspace mykolasuprun/nixvim:lazyvim-latest .

# CodeVim
docker run --rm -it -v "$(pwd)":/workspace -w /workspace mykolasuprun/nixvim:codevim-latest .
```

### Manual Build / Load / Run

If you prefer to run the commands yourself:

```bash
# Build
nix build .#docker-nixvim

# Load into Docker
docker load < result

# Run interactively
docker run --rm -it nixvim:latest

# Run with a host directory mounted
docker run --rm -it -v "$(pwd)":/workspace -w /workspace nixvim:latest .

# Run LazyVim
docker run --rm -it -v "$(pwd)":/workspace -w /workspace lazyvim:latest .

# Run CodeVim
docker run --rm -it -v "$(pwd)":/workspace -w /workspace codevim:latest .
```

**Important:** The image is built with `/bin/nvim` as the entrypoint. If you need a shell inside the container for debugging, override the entrypoint:

```bash
docker run --rm -it --entrypoint /bin/sh nixvim:latest
```

### Environment Variables, Colors, and Terminal Integration

Neovim inside Docker can see your host environment if you pass it through. This is essential for colorscheme switching, tmux integration, and true-color support. The `docker-run.sh` script forwards these automatically; when running manually, pass them with `-e`:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -e TERM \
  -e COLORTERM \
  -e BAT_THEME \
  -e STYLIX_COLORSCHEME \
  -e TMUX \
  -e TMUX_PANE \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

**What each variable does:**

| Variable | Purpose |
|----------|---------|
| `TERM` | Tells Neovim your terminal capabilities (e.g., `xterm-256color`, `tmux-256color`, `alacritty`) |
| `COLORTERM` | Signals true-color support (`truecolor` or `24bit`). Without this, Neovim falls back to `habamax` (basic 16-color scheme) |
| `STYLIX_COLORSCHEME` | **Colorscheme override.** If set and `COLORTERM` indicates truecolor support, Neovim loads this colorscheme instead of the default `catppuccin-latte`. Example: `STYLIX_COLORSCHEME=catppuccin-frappe` |
| `BAT_THEME` | Sets the theme for `bat` (used by plugins like Telescope preview) |
| `TMUX` / `TMUX_PANE` | Enables tmux integration (clipboard, pane detection, `tmux` keybindings) |

**Colorscheme behavior:**
- If `COLORTERM` is *not* set to `truecolor`/`24bit` → uses `habamax` (safe for Linux TTY/serial consoles)
- If `COLORTERM` *is* set and `STYLIX_COLORSCHEME` is set → uses the Stylix colorscheme specified
- If `COLORTERM` *is* set but `STYLIX_COLORSCHEME` is *not* set → uses default `catppuccin-latte`

**Tmux integration** requires mounting the tmux socket into the container:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v "${TMUX%%,*}:/tmp/tmux.sock:ro" \
  -e TMUX="/tmp/tmux.sock" \
  -e TERM=tmux-256color \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

**True-color test** — run this inside the container to verify colors work:

```bash
# Inside the container
printf '\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n'
```

## Adding a New Config File

1. Create the `.nix` file in the appropriate config directory.
2. Add it to that config's `default.nix` imports list.
3. Run `nix flake check` to verify.
