# nixvim-specific option overrides — settings that only apply to full Neovim
# (not the VSCode embedded codevim build). Shared opts live in ../shared/options.nix.
{pkgs, ...}: {
  opts = {
    # Show the tab bar always (VSCode manages tabs in codevim, so this stays here)
    showtabline = 2;
  };
  globals = {
    # Enable snacks indent guides by default; exposed as a toggle via <leader>ui
    snacks_indent_enabled = true;
  };
  clipboard = {
    # Override shared clipboard register to empty — nixvim uses native providers
    # instead of unnamedplus so that xclip/wl-copy handle the bridge explicitly.
    register = "";
    providers = {
      # Enable X11 and Wayland clipboards only on Linux
      xclip.enable = pkgs.stdenv.isLinux;
      wl-copy.enable = pkgs.stdenv.isLinux;
      # Enable macOS clipboard only on Darwin
      pbcopy.enable = pkgs.stdenv.isDarwin;
    };
  };
}
