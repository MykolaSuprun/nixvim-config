{pkgs, ...}: {
  plugins = {
    overseer = {
      enable = true;
      luaConfig.post = builtins.readFile ./ruff_check.lua;
    };
  };
}
