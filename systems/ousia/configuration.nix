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
  llama-cpp =
    (pkgs.llama-cpp.override {
      cudaSupport = true;
      rocmSupport = false;
      metalSupport = false;
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        pname = "prism-llama-cpp";
        version = "9591";
        commit = "62061f9";
        src = pkgs.fetchFromGitHub {
          owner = "PrismML-Eng";
          repo = "llama.cpp";
          tag = "prism-b${version}-${commit}";
          hash = "sha256-zLxB5UKnCTCw/okB+L8u1VtM1o2yVjVYTlTBgL/BsaM=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };
        npmDepsHash = "sha256-pjdbI6NcZRlJVd62xhgbLhWrwFYwgsIwjORqvo1+VD8=";
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DGGML_NATIVE=ON"
        ];
        preConfigure = ''
          export NIX_ENFORCE_NO_NATIVE=0
          ${oldAttrs.preConfigure or ""}
        '';
      });
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
      "prism-ml/Ternary-Bonsai-27B" = {
        m = pkgs.homa.fetchFromHuggingFace {
          repo = "prism-ml/Ternary-Bonsai-27B-gguf";
          file = "Ternary-Bonsai-27B-Q2_0.gguf";
          version = "20e435f518bd5b882795954aba81e80a91894321";
          hash = "sha256-howRcUz4/kf17J7rK+CrGjNxEohvku4O3muFXE+jF1c=";
        };
        jinja = true;
        ngl = 999;
        c = 100000;
        ctk = "q4_0";
        ctv = "q4_0";
        threads = 8;
        threads-batch = 16;
        batch-size = 2048;
        ubatch-size = 512;
        flash-attn = "on";
        temp = 0.7;
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
