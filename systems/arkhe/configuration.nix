# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.systemd-boot.consoleMode = lib.mkDefault "max";
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/boot";
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  fileSystems = {
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  networking.hostName = "arkhe"; # Define your hostname.

  services.davinci.enable = true;

  services.aero.video-wallpaper.enable = true;

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { cudaSupport = true; };
    modelsPreset = {
      "gpt-oss-20b" = {
        hf-repo = "ggml-org/gpt-oss-20b-GGUF";
        hf-file = "gpt-oss-20b-mxfp4.gguf";
        alias = "openai/gpt-oss-20b";
        ctx-size = 0;
        batch-size = 2048;
        ubatch-size = 2048;
        flash-attn = "on";
        n-cpu-moe = 16;
      };
    };
  };

  home-manager.users.ducanh = {
    programs.opencode.enable = true;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  hardware.bluetooth.enable = true;
}
