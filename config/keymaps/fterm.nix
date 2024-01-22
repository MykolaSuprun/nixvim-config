{
  keymaps = [
    {
      mode = "n";
      key = "<A-i>";
      options.silent = true;
      action = ''<cmd>lua require("FTerm").toggle()<cr>'';
    }
    {
      mode = "t";
      key = "<A-i>";
      options.silent = true;
      action = ''<cmd>lua require("FTerm").toggle()<cr>'';
    }
  ];
}
