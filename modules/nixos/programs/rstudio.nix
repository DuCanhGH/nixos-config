{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.rstudio;
  r-pkgs = with pkgs.rPackages; [
    knitr
    htmltools
    jsonlite
    magrittr
    mime
    rmarkdown
    stringi
    stringr
  ];
  r-env = pkgs.rWrapper.override {
    packages = r-pkgs;
  };
  rstudio = pkgs.rstudioWrapper.override {
    packages = r-pkgs;
  };
in
{
  options.programs.rstudio.enable = lib.mkEnableOption "RStudio IDE";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      r-env
      rstudio
    ];
  };
}
