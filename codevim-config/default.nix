{
  # codevim — a lean Neovim configuration for VSCode embedded mode (vscode-neovim).
  # Inherits shared editing primitives and options from ../shared/.
  # All LSP, navigation, and UI actions are delegated to VSCode via require('vscode').
  imports = [
    ../shared/options.nix
    ../shared/editing.nix
    ../shared/plugins.nix
    ../shared/keymaps.nix
    ./dependencies.nix
    ./lsp.nix
    ./plugins.nix
    ./keymaps.nix
  ];
}
