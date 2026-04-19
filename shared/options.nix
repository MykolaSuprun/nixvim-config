# Shared options — imported by both nixvim-config and codevim-config.
# Only settings that are valid and meaningful in both full Neovim and VSCode
# embedded mode belong here.
{lib, ...}: {
  opts = {
    # use spaces instead of tabs
    expandtab = true;
    # tab length and indent shift
    tabstop = 2;
    shiftwidth = 2;
    # smart auto tab
    smarttab = true;
    smartindent = true;
    breakindent = true;
    # round indents
    shiftround = true;
    # line numbers
    number = true;
    relativenumber = true;
    # 24-bit RGB color support
    termguicolors = true;
    timeout = true;
    timeoutlen = 300;
    # window splits
    splitright = true;
    splitbelow = true;
    # configure grep to use ripgrep
    grepprg = "rg --vimgrep --no-heading --smart-case";
    grepformat = "%f:%l:%c:%m,%f:%l:%m";
  };
  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };
  # Sync to system clipboard — VSCode bridges OS clipboard natively, so
  # no xclip/wl-copy providers are needed in codevim.
  # nixvim-config/options.nix overrides this to "" with native providers.
  clipboard.register = lib.mkDefault "unnamedplus";
  performance = {
    byteCompileLua.enable = true;
  };
}
