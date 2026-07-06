# nixvim-specific option overrides — settings that only apply to full Neovim
# (not the VSCode embedded codevim build). Shared opts live in ../shared/options.nix.
{...}: {
  opts = {
    # Show the tab bar always (VSCode manages tabs in codevim, so this stays here)
    showtabline = 2;
  };
  globals = {
    # Enable snacks indent guides by default; exposed as a toggle via <leader>ui
    snacks_indent_enabled = true;
  };
  clipboard = {
    # Always use OSC 52 for clipboard. This works in Docker, SSH, tmux, and
    # virtually all modern terminals without needing xclip, wl-copy, or pbcopy.
    # Native providers are disabled to avoid silent failures in containerized
    # or headless environments.
    register = "";
    providers = {
      xclip.enable = false;
      wl-copy.enable = false;
      pbcopy.enable = false;
    };
  };
  extraConfigLua = ''
    -- OSC 52 clipboard — works via terminal escape sequences.
    -- Supported by iTerm2, WezTerm, Alacritty, GNOME Terminal, tmux, etc.
    vim.g.clipboard = {
      name = "OSC 52",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
      },
    }
  '';
}
