{pkgs, ...}: {
  plugins = {
    overseer = {
      enable = true;
      # concatStringsSep with an explicit "\n": plain `+` concatenation is
      # correct only while every file ends with a trailing newline — one
      # missing newline would merge `end` + `local` into `endlocal` and break
      # every template at startup.
      luaConfig.post = builtins.concatStringsSep "\n" [
        (builtins.readFile ./ruff_check.lua)
        (builtins.readFile ./python_tasks.lua)
        (builtins.readFile ./nix_tasks.lua)
        (builtins.readFile ./go_tasks.lua)
        (builtins.readFile ./lua_tasks.lua)
        (builtins.readFile ./cc_tasks.lua)
        (builtins.readFile ./dbt_tasks.lua)
        (builtins.readFile ./snowflake_tasks.lua)
        (builtins.readFile ./airflow_tasks.lua)
      ];
    };
  };
}
