{
  vim.autocomplete.blink-cmp = {
    enable = true;
    mappings = {
      close = "<C-e>";
      complete = "<C-space>";
      confirm = "<CR>";
      next = "<C-n>";
      previous = "<C-p>";
    };
    setupOpts = {
      sources = {
        default = [
          "lsp"
          "path"
          "buffer"
        ];
      };
      completion = {
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        menu.draw.treesitter = [ "lsp" ];
      };
    };
  };
}
