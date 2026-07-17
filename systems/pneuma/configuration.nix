# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  config,
  lib,
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
    loader.systemd-boot.xbootldrMountPoint = "/boot";
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/efi";
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  fileSystems = {
    "/efi/EFI/Linux" = {
      device = "/boot/EFI/Linux";
      fsType = "vfat";
      options = [ "bind" ];
    };
    "/efi/EFI/nixos" = {
      device = "/boot/EFI/nixos";
      fsType = "vfat";
      options = [ "bind" ];
    };
    "/swap".options = [ "noatime" ];
  };

  networking.hostName = "pneuma"; # Define your hostname.

  environment.systemPackages = [ llama-cpp ];

  services.aero = {
    wayland.enable = true;
    plymouth.delay = 5;
    video-wallpaper.enable = true;
  };

  services.asusd.enable = true;

  services.supergfxd.enable = true;

  services.amdgpu.enable = true;

  services.llama-cpp = {
    enable = true;
    package = llama-cpp;
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "Qwen/Qwen3.5-9B" = {
        hf-repo = "unsloth/Qwen3.5-9B-MTP-GGUF";
        hf-file = "Qwen3.5-9B-UD-IQ3_XXS.gguf";
        jinja = true;
        ngl = 999;
        c = 131072;
        ctk = "q8_0";
        ctv = "q8_0";
        threads = 6;
        threads-batch = 12;
        batch-size = 2048;
        ubatch-size = 512;
        flash-attn = "on";
        temp = 0.6;
        top-p = 0.95;
        top-k = 20;
        min-p = 0.0;
        presence-penalty = 0.0;
        repeat-penalty = 1.0;
        no-mmproj = true;
      };
    };
  };

  home-manager.users.ducanh = {
    programs.opencode = {
      enable = true;
      settings.provider."llama.cpp".models = {
        "Qwen/Qwen3.5-9B" = {
          name = "Qwen3.5-9B (local)";
          limit = {
            context = 131072;
            output = 32768;
          };
        };
      };
    };
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:0@65:00:0";
    nvidiaBusId = "PCI:0@01:0:0";
  };
}
