{
  vim = {
    lsp.enable = true;
    languages = {
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      nix = {
        enable = true;
        lsp.enable = true;
        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
      };
      clang = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
      rust.enable = true;
      markdown.enable = true;
      typst.enable = true;
      html.enable = true;
      css.enable = true;
      svelte = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        treesitter.enable = true;
      };
      tailwind.enable = true;
      ts = {
        enable = true;
        lsp.enable = true;
        format.enable = true;
        treesitter.enable = true;
        extensions.ts-error-translator.enable = true;
      };
    };
  };
}
