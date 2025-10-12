{pkgs, ...}: {
  opts = {
    # use spaces instead of tabs
    expandtab = true;
    # set tab lenght and indent shift to 2
    tabstop = 2;
    shiftwidth = 2;
    # smart auto tab
    smarttab = true;
    smartindent = true;
    breakindent = true;
    # round indents
    shiftround = true;
    # enable relative line number
    number = true;
    relativenumber = true;
    # enable 24-bit RGB color support
    termguicolors = true;
    timeout = true;
    timeoutlen = 300;
    # how to split windows
    splitright = true;
    splitbelow = true;
  };
  globals = {
    # set up leader key
    mapleader = " ";
    maplocalleader = "\\";
  };
  clipboard = {
    register = "unnamedplus";
    providers = {
      xclip.enable = true;
      wl-copy.enable = true;
    };
  };
  performance = {
    byteCompileLua.enable = true;
  };
}
