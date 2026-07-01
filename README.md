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
  lsp.nix         # LSP servers and completion
  plugins.nix     # nixvim-only plugins (snacks, noice, oil, avante, …)
  keymaps.nix     # nixvim-only keymaps (pickers, tabs, UI, copilot, …)
  visual.nix      # Colorscheme and visual options
  overseer/       # Overseer task runner config and custom tasks

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

### Build

```bash
# Full NixVim image
nix build .#docker-nixvim

# LazyVim image
nix build .#docker-lazyvim

# CodeVim image
nix build .#docker-codevim
```

### Load and Run

```bash
# Load the image into Docker
docker load < result

# Run Neovim interactively
docker run --rm -it nixvim:latest

# Run with a host directory mounted
docker run --rm -it -v "$(pwd)":/workspace nixvim:latest

# Run LazyVim
docker run --rm -it lazyvim:latest

# Run CodeVim
docker run --rm -it codevim:latest
```

### Using as a Normal Neovim App

To use the Docker image like a regular Neovim installation, mount your working directory and enable interactive TTY mode:

```bash
# Edit current directory
docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

With your dotfiles mounted (git config, SSH keys, etc.):

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

**Shell alias** (add to `~/.bashrc` or `~/.zshrc`):

```bash
alias nvim-docker='docker run --rm -it -v "$PWD:/workspace" -w /workspace nixvim:latest'
```

Then use it exactly like normal Neovim:

```bash
nvim-docker .
nvim-docker src/main.rs
nvim-docker +"Telescope find_files"
```

**Important:** The image is built with `/bin/nvim` as the entrypoint. If you need a shell inside the container for debugging, override the entrypoint:

```bash
docker run --rm -it --entrypoint /bin/sh nixvim:latest
```

### Environment Variables, Colors, and Terminal Integration

Neovim inside Docker can see your host environment if you pass it through. This is essential for colorscheme switching, tmux integration, and true-color support:

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

**Full-featured alias** with everything wired up:

```bash
alias nvim-docker='docker run --rm -it \
  -v "$PWD:/workspace" \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  -e TERM -e COLORTERM -e BAT_THEME -e STYLIX_COLORSCHEME -e TMUX -e TMUX_PANE \
  -w /workspace \
  nixvim:latest'
```

### Clipboard Integration

Clipboard inside Docker requires special handling. The config uses native providers (`xclip`/`wl-copy` on Linux, `pbcopy` on macOS), but in a container these need help to reach the host.

**Option 1: OSC 52 (Recommended — works everywhere)**

OSC 52 is a terminal escape sequence that works through any terminal emulator, including SSH, tmux, and both macOS and Linux. Your terminal must support it (iTerm2, WezTerm, Alacritty, GNOME Terminal, and most modern terminals do).

Enable it in Neovim by setting the provider inside the container:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -e TERM -e COLORTERM \
  -e NVIM_CLIPBOARD_PROVIDER=osc52 \
  -w /workspace \
  nixvim:latest \
  -c 'lua vim.g.clipboard = { name = "OSC 52", copy = { ["+"] = require("vim.ui.clipboard.osc52").copy("+"), ["*"] = require("vim.ui.clipboard.osc52").copy("*") }, paste = { ["+"] = require("vim.ui.clipboard.osc52").paste("+"), ["*"] = require("vim.ui.clipboard.osc52").paste("*") } }' \
  "${@:-.}"
```

Or add to your alias:

```bash
alias nvim-docker='docker run --rm -it \
  -v "$PWD:/workspace" \
  -e TERM -e COLORTERM -e BAT_THEME -e STYLIX_COLORSCHEME \
  -w /workspace \
  nixvim:latest \
  -c "lua vim.g.clipboard = { name = \"OSC 52\", copy = { [\\\"+\\\"] = require(\\\"vim.ui.clipboard.osc52\").copy(\\\"+\\\"), [\\\"*\\\"] = require(\\\"vim.ui.clipboard.osc52\").copy(\\\"*\\\") }, paste = { [\\\"+\\\"] = require(\\\"vim.ui.clipboard.osc52\").paste(\\\"+\\\"), [\\\"*\\\"] = require(\\\"vim.ui.clipboard.osc52\").paste(\\\"*\\\") } }"'
```

**Option 2: X11 forwarding (Linux desktop only)**

Mount the X11 socket and authenticate:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -e DISPLAY \
  -e TERM -e COLORTERM \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

**Option 3: Wayland (Linux desktop only)**

Mount the Wayland socket:

```bash
docker run --rm -it \
  -v "$PWD:/workspace" \
  -v "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/wayland.sock:ro" \
  -e WAYLAND_DISPLAY=/tmp/wayland.sock \
  -e TERM -e COLORTERM \
  -w /workspace \
  nixvim:latest \
  "${@:-.}"
```

**Option 4: macOS host clipboard via Docker Desktop (macOS only)**

Docker Desktop for Mac has built-in clipboard sharing that works automatically when using `pbcopy`/`pbpaste`. The config already enables `pbcopy` provider on Darwin builds. However, in a Linux container, you need OSC 52 or a bridge like `docker-mac-net-connect`.

### Docker Desktop on macOS

When running these images on macOS via Docker Desktop, keep in mind:

- The image is a **Linux container**, so the `pbcopy` provider is not available inside it (it's only enabled on Darwin builds). Use **OSC 52** for clipboard instead.
- Volume mounts use Docker Desktop's file sharing. Performance is best under `~` (your home directory).
- The tmux socket path on macOS is typically under `/tmp`, so tmux integration works the same way as on Linux.
- Terminal apps like iTerm2, WezTerm, and Terminal.app all support OSC 52 for clipboard.

**Recommended macOS alias:**

```bash
alias nvim-docker='docker run --rm -it \
  -v "$PWD:/workspace" \
  -e TERM -e COLORTERM -e BAT_THEME -e STYLIX_COLORSCHEME \
  -w /workspace \
  nixvim:latest \
  -c "lua vim.g.clipboard = { name = \"OSC 52\", copy = { [\\\"+\\\"] = require(\\\"vim.ui.clipboard.osc52\").copy(\\\"+\\\"), [\\\"*\\\"] = require(\\\"vim.ui.clipboard.osc52\").copy(\\\"*\\\") }, paste = { [\\\"+\\\"] = require(\\\"vim.ui.clipboard.osc52\").paste(\\\"+\\\"), [\\\"*\\\"] = require(\\\"vim.ui.clipboard.osc52\").paste(\\\"*\\\") } }"'
```

**Testing clipboard:**

After starting Neovim, run:

```vim
:checkhealth clipboard
```

This shows which provider is active and whether it's working.

### Transfer to Another Machine

```bash
# Build and export as a tarball
nix build .#docker-nixvim
docker load < result
docker save nixvim:latest | gzip > nixvim-docker.tar.gz

# On the target machine (no Nix needed)
gunzip < nixvim-docker.tar.gz | docker load
docker run --rm -it nixvim:latest
```

## Adding a New Config File

1. Create the `.nix` file in the appropriate config directory.
2. Add it to that config's `default.nix` imports list.
3. Run `nix flake check` to verify.
