{pkgs, ...}: {
  plugins = {
    overseer = {
      enable = true;
      luaConfig.post =
        builtins.readFile ./ruff_check.lua
        + builtins.readFile ./python_tasks.lua
        + builtins.readFile ./nix_tasks.lua
        + builtins.readFile ./go_tasks.lua
        + builtins.readFile ./lua_tasks.lua
        + builtins.readFile ./dbt_tasks.lua;
    };
  };
}
