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

## Adding a New Config File

1. Create the `.nix` file in the appropriate config directory.
2. Add it to that config's `default.nix` imports list.
3. Run `nix flake check` to verify.
