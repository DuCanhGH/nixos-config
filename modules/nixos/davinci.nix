{ config, lib, pkgs, ... }: {
  options.services.davinci = {
    enable = lib.mkEnableOption "Whether to install the DaVinci Resolve.";
  };
  config = lib.mkIf config.services.davinci.enable {
    environment.systemPackages = with pkgs; [
      davinci-resolve
    ];
  };
}