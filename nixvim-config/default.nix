{
  # Import all your configuration modules here
  imports = [
    # Shared modules — also imported by codevim-config
    ../shared/options.nix
    ../shared/editing.nix
    ../shared/plugins.nix
    ../shared/keymaps.nix
    # nixvim-specific modules
    ./dependencies.nix
    ./options.nix
    ./visual.nix
    ./lsp.nix
    ./plugins.nix
    ./keymaps.nix
    ./overseer
  ];
}
