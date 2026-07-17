# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  config,
  lib,
  homa,
  ...
}:
let
  llama-cpp = pkgs.llama-cpp.override { cudaSupport = true; };
in
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

  networking.hostName = "ousia"; # Define your hostname.

  environment.systemPackages = [ llama-cpp ];

  services.davinci.enable = true;

  services.aero.video-wallpaper.enable = true;

  services.llama-cpp = {
    enable = true;
    package = llama-cpp;
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "Qwen/Qwen3.6-35B-A3B-MTP" = {
        m = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF";
          file = "Qwen3.6-35B-A3B-UD-Q4_K_M.gguf";
          version = "5bc3e238d916f48a861bac2f8a1990a0e9b7e98d";
          hash = "sha256-CyFSXpcmcO1Z4YEuFwsnwmNVOB8GVuzE4lYX7OfaxYs=";
        };
        mmproj = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF";
          file = "mmproj-BF16.gguf";
          version = "5bc3e238d916f48a861bac2f8a1990a0e9b7e98d";
          hash = "sha256-2mPLR6dnY8cSOT+KAXBwGIowT6Ofiu6m7cYp7XuXXPo=";
        };
        jinja = true;
        spec-type = "draft-mtp";
        spec-draft-n-max = 2;
        ctk = "q8_0";
        ctv = "q8_0";
        fit = "on";
        fit-ctx = 262144;
        fit-target = 512;
        threads = 8;
        threads-batch = 16;
        batch-size = 2048;
        ubatch-size = 512;
        flash-attn = "on";
        temp = 0.6;
        top-p = 0.95;
        top-k = 20;
        min-p = 0.0;
        presence-penalty = 0.0;
        repeat-penalty = 1.0;
      };
    };
  };

  home-manager.users.ducanh = {
    programs.opencode = {
      enable = true;
      settings.provider."llama.cpp".models = {
        "Qwen/Qwen3.6-35B-A3B-MTP" = {
          name = "Qwen3.6-35B-A3B-MTP (local)";
          limit = {
            context = 262144;
            output = 32768;
          };
        };
        "prism-ml/Ternary-Bonsai-27B" = {
          name = "Ternary-Bonsai-27B (local)";
          limit = {
            context = 100000;
            output = 32768;
          };
        };
      };
    };
  };

  hardware.bluetooth.enable = true;
}
