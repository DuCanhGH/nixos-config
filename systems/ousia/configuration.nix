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
  qwenCodingParams = {
    flash-attn = "on";
    temp = 0.6;
    top-p = 0.95;
    top-k = 20;
    min-p = 0.0;
    presence-penalty = 0.0;
    repeat-penalty = 1.0;
    reasoning-preserve = true;
  };
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

  systemd.services.llama-cpp = {
    environment = {
      GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
    };
  };

  services.davinci.enable = true;

  services.aero.video-wallpaper.enable = true;

  services.amdgpu.enable = true;

  services.llama-cpp = {
    enable = true;
    package = llama-cpp;
    settings.cors-origins = "localhost";
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "Qwen/Qwen3.6-35B-A3B-MTP" = qwenCodingParams // {
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
        ag = true;
        ts = "2.83,1";
        jinja = true;
        ngl = 999;
        c = 262144;
        np = 4;
        n-cpu-moe = 20;
        spec-type = "draft-mtp";
        spec-draft-n-max = 2;
        kvu = true;
        ctk = "q8_0";
        ctv = "q8_0";
        threads = 8;
        batch-size = 512;
        ubatch-size = 512;
        image-min-tokens = 1024;
      };
      "Qwen/Qwen3.6-27B-MTP" = qwenCodingParams // {
        m = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Qwen3.6-27B-MTP-GGUF";
          file = "Qwen3.6-27B-IQ4_XS.gguf";
          version = "5cb35eb3dcbf52dbce5f87dbc64df6aaffadcace";
          hash = "sha256-+rMzU9rXmD6cM7rm/NrnwSzf4Dt9e13CNmUcrVUXrSs=";
        };
        mmproj = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Qwen3.6-27B-MTP-GGUF";
          file = "mmproj-BF16.gguf";
          version = "5cb35eb3dcbf52dbce5f87dbc64df6aaffadcace";
          hash = "sha256-BTUzR1Epgu5iMXudjIk3K8gV9LQENYDn7zrUEewaHNM=";
        };
        ag = true;
        sm = "tensor";
        ts = "12,8";
        jinja = true;
        ngl = 999;
        c = 100096;
        np = 4;
        spec-type = "draft-mtp,ngram-mod";
        spec-draft-n-max = 2;
        kvu = true;
        ctk = "q4_0";
        ctv = "q4_0";
        threads = 8;
        batch-size = 512;
        ubatch-size = 512;
        image-min-tokens = 1024;
        no-mmproj-offload = true;
      };
    };
  };

  services.udev.extraHwdb = ''
    evdev:input:b0003v25A7p2301e0110*
      KEYBOARD_KEY_700e3=space
  '';

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
          modalities = {
            input = [
              "text"
              "image"
            ];
          };
        };
        "Qwen/Qwen3.6-27B-MTP" = {
          name = "Qwen3.6-27B-MTP (local)";
          limit = {
            context = 131072;
            output = 32768;
          };
          modalities = {
            input = [
              "text"
              "image"
            ];
          };
        };
      };
    };
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1@0:0:0";
    amdgpuBusId = "PCI:13@0:0:0";
  };
}
