{
  config = {
    opts = {
      # use spaces instead of tabs
      expandtab = true;
      # set tab lenght and indent shift to 2
      tabstop = 2;
      shiftwidth = 2;
      # round indents
      shiftround = true;
      # smart auto tab
      smarttab = true;
      smartindent = true;
      breakindent = true;
      # enable relative line number
      number = true;
      relativenumber = true;
      # confirm save on closing buffer
      confirm = true;
      # completion options, for more info: https://neovim.io/doc/user/options.html#'completeopt'
      completeopt = "menu,menuone,noselect,noinsert";
      # use smartcase for search
      smartcase = true;
      # how to split windows
      splitright = true;
      splitbelow = true;
      # enable 24-bit RGB color support
      termguicolors = true;
      timeout = true;
      timeoutlen = 300;
    };
  };
}
