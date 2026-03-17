{
  vim.formatter.conform-nvim = {
    enable = true;
    setupOpts = {
      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };
    };
  };
}
