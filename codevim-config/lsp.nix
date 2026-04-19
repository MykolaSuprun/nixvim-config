# codevim LSP configuration.
# No language servers are started — VSCode owns all LSP functionality.
# Inlay hints are disabled; VSCode renders those natively.
{...}: {
  lsp.inlayHints.enable = false;
  plugins.lspconfig.enable = true;
}
