{
  plugins.yanky = {
    enable = true;
    extraOptions = {
      highlight = {
        timer = 200;
      };
    };
  };
  keymaps = [
    {
      mode = ["n" "x"];
      key = "p";
      options = {
        silent = true;
      };
      action = "<Plug>(YankyPutAfter)";
    }
    {
      mode = ["n" "x"];
      key = "P";
      options = {
        silent = true;
      };
      action = "<Plug>(YankyPutBefore)";
    }
    {
      mode = ["n" "x"];
      key = "gp";
      options = {
        silent = true;
      };
      action = "<Plug>(YankyGPutAfter)";
    }
    {
      mode = ["n" "x"];
      key = "gP";
      options = {
        silent = true;
      };
      action = "<Plug>(YankyGPutBefore)";
    }
  ];
}
