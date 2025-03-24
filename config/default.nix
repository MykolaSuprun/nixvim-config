{nvim-mode}: {
  # Import all your configuration modules here
  imports =
    if nvim-mode == "nvim"
    then [
      ./plugins
      ./keymaps
      ./colorschemes.nix
      ./options.nix
    ]
    else [
    ];
}
