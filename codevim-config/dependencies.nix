{pkgs, ...}: {
  # Minimal set of tools needed by codevim in VSCode embedded mode.
  # Heavy tools (lazygit, image rendering, terminal multiplexer integrations)
  # are intentionally excluded — VSCode provides those capabilities natively.
  extraPackages = with pkgs; [
    ripgrep
    fd
    git
    ruff
    stylua
  ];
}
