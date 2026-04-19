# codevim keymaps — VSCode-specific delegation only.
# All shared keymaps (diagnostics, flash, gitsigns, format, grug-far, trouble,
# persistence, snacks git/notifications) are in ../shared/keymaps.nix.
{...}: {
  keymaps = [
    # --- LSP / Navigation (delegate to VSCode) ---
    # Shared keymaps use vim.diagnostic; these use VSCode's native LSP for nav.
    {
      key = "gd";
      options = {silent = true; desc = "Go to Definition";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.revealDefinition') end'';
    }
    {
      key = "gD";
      options = {silent = true; desc = "Go to Declaration";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.revealDeclaration') end'';
    }
    {
      key = "gr";
      options = {silent = true; desc = "Go to References";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.goToReferences') end'';
    }
    {
      key = "gI";
      options = {silent = true; desc = "Go to Implementation";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.goToImplementation') end'';
    }
    {
      key = "gy";
      options = {silent = true; desc = "Go to Type Definition";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.goToTypeDefinition') end'';
    }
    {
      key = "K";
      options = {silent = true; desc = "Show Hover";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.showHover') end'';
    }
    {
      key = "<leader>ca";
      options = {silent = true; desc = "Code Actions";};
      mode = ["n" "x"];
      action.__raw = ''function() require('vscode').action('editor.action.quickFix') end'';
    }
    {
      key = "<leader>cr";
      options = {silent = true; desc = "Rename Symbol";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('editor.action.rename') end'';
    }

    # --- UI / Panels (delegate to VSCode) ---
    {
      key = "<leader>xv";
      options = {silent = true; desc = "VSCode Problems Panel";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.actions.view.problems') end'';
    }
    {
      key = "<leader>ff";
      options = {silent = true; desc = "Quick Open File";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.action.quickOpen') end'';
    }
    {
      key = "<leader>/";
      options = {silent = true; desc = "Find in Files";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.action.findInFiles') end'';
    }
    {
      key = "<leader>e";
      options = {silent = true; desc = "Explorer";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.view.explorer') end'';
    }
    {
      key = "<leader>gg";
      options = {silent = true; desc = "Source Control";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.view.scm') end'';
    }
    {
      key = "<leader>:";
      options = {silent = true; desc = "Command Palette";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.action.showCommands') end'';
    }
    {
      key = "<leader>p";
      options = {silent = true; desc = "Command Palette";};
      mode = ["n"];
      action.__raw = ''function() require('vscode').action('workbench.action.showCommands') end'';
    }
  ];
}
