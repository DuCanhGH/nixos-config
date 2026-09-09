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
      blasSupport = true;
    }).overrideAttrs
      (oldAttrs: rec {
        version = "10868";
        src = pkgs.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          tag = "b${version}";
          hash = "sha256-lUVCG6QymqROZX/W0mqUTWBSZ3J7J2o7fGe4bkca1yo=";
          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };
        npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
        cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
          "-DGGML_NATIVE=ON"
        ];
        preConfigure = ''
          export NIX_ENFORCE_NO_NATIVE=0
          ${oldAttrs.preConfigure or ""}
        '';
      });
  qwen-27b-ud-iq4_xs = pkgs.homa.fetchFromHuggingFace {
    repo = "unsloth/Qwen3.8-27B-GGUF";
    file = "Qwen3.8-27B-UD-IQ4_XS.gguf";
    version = "4ca720788d1e01f1bff70c033e0d0028fd02e502";
    hash = "sha256-QPrEBQ6UA5fb8TCHr9UPRzShGAW/nWXvjd10g0cOYZk=";
  };
  qwen-thinking-params = {
    flash-attn = "on";
    temp = 1.0;
    top-p = 0.95;
    top-k = 20;
    min-p = 0.0;
    presence-penalty = 0.0;
    repeat-penalty = 1.0;
    reasoning-preserve = true;
  };
  qwen-27b-params = qwen-thinking-params // {
    mmproj = pkgs.homa.fetchFromHuggingFace {
      repo = "unsloth/Qwen3.8-27B-GGUF";
      file = "mmproj-BF16.gguf";
      version = "4ca720788d1e01f1bff70c033e0d0028fd02e502";
      hash = "sha256-g+5PTyBfpRQWF3jEHfHqFBRPqg9xNRCJO2PCOV9cLVM=";
    };
    ag = true;
    sm = "tensor";
    ts = "1.66,1";
    jinja = true;
    ngl = 999;
    np = 4;
    kvu = true;
    spec-type = "draft-mtp,ngram-mod";
    spec-draft-n-max = 2;
    threads = 8;
    batch-size = 2048;
    ubatch-size = 512;
    image-min-tokens = 1024;
  };
  qwen-opencode-config = {
    modalities = {
      input = [
        "text"
        "audio"
        "image"
        "video"
        "pdf"
      ];
    };
    options = {
      reasoningEffort = "xhigh";
      textVerbosity = "low";
      reasoningSummary = "auto";
    };
    variants = {
      medium = {
        reasoningEffort = "medium";
        textVerbosity = "low";
        reasoningSummary = "auto";
      };
      low = {
        reasoningEffort = "low";
        textVerbosity = "low";
        reasoningSummary = "auto";
      };
    };
  };
in
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  time.timeZone = "America/Indianapolis";

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

  programs.ccache.packageNames = [ "llama-cpp" ];

  programs.davinci.enable = true;

  programs.rstudio.enable = true;

  systemd.services.llama-cpp = {
    environment = {
      GGML_CUDA_ENABLE_UNIFIED_MEMORY = "1";
    };
  };

  services.aero.video-wallpaper.enable = true;

  services.amdgpu.enable = true;

  services.llama-cpp = {
    enable = true;
    package = llama-cpp;
    settings.cors-origins = "localhost";
    settings.models-max = 1;
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "Qwen/Qwen3.8-27B" = qwen-27b-params // {
        m = qwen-27b-ud-iq4_xs;
        c = 100096;
        ctk = "q8_0";
        ctv = "q8_0";
        no-mmproj-offload = true;
      };
      "Qwen/Qwen3.8-27B-Vision" = qwen-27b-params // {
        m = qwen-27b-ud-iq4_xs;
        c = 65536;
        ctk = "q8_0";
        ctv = "q8_0";
      };
      "Qwen/Qwen3.8-27B-FFN@IQ3_S" = qwen-27b-params // {
        m = pkgs.homa.fetchFromHuggingFace {
          repo = "canhdu/Qwen3.8-27B-IQ3_S-FFN-IQ4_XS";
          file = "Qwen3.8-27B-IQ3_S-FFN-IQ4_XS.gguf";
          version = "409e7b548b543fc17fb7c37733ca90614f1090d7";
          hash = "sha256-FXR5sAg2YsfJz9h1TK4kq5zBq71N75HUl1hRLJDx5AY=";
        };
        c = 100096;
        ctk = "q8_0";
        ctv = "q8_0";
        no-mmproj-offload = true;
      };
      "Meta/Muse-Glimmer-30B" = {
        m = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Muse-Glimmer-30B-GGUF";
          file = "Muse-Glimmer-30B-UD-Q4_K_XL.gguf";
          version = "faa5b025c584459c13febfa5c59883516710ae39";
          hash = "sha256-gr7OMEiHoxPs4IQAvAMPYGbHv/W5BrDNQDCOyKQJ/Tg=";
        };
        md = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Muse-Glimmer-30B-GGUF";
          file = "dflash-kquant.gguf";
          version = "faa5b025c584459c13febfa5c59883516710ae39";
          hash = "sha256-J9moBfopuUPPtq1IQzZ81Oqq8GvUUtjMPgCizRimd7w=";
        };
        mmproj = pkgs.homa.fetchFromHuggingFace {
          repo = "unsloth/Muse-Glimmer-30B-GGUF";
          file = "mmproj-kquant.gguf";
          version = "faa5b025c584459c13febfa5c59883516710ae39";
          hash = "sha256-9ItFIxb5shN1joZZREApuWGiSgf5mhq7Kp+IsG98AMY=";
        };
        ag = true;
        sm = "layer";
        ts = "12,8";
        jinja = true;
        ngl = 999;
        c = 131072;
        np = 4;
        spec-type = "draft-dflash";
        spec-draft-n-max = 15;
        kvu = true;
        ctk = "q8_0";
        ctv = "q8_0";
        threads = 8;
        batch-size = 512;
        ubatch-size = 512;
        no-mmproj-offload = true;
        temp = 1.0;
        top-p = 0.95;
        top-k = 64;
        reasoning-preserve = true;
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
        "Qwen/Qwen3.8-27B" = qwen-opencode-config // {
          name = "Qwen3.8-27B (local, IQ4_XS)";
          limit = {
            context = 100096;
            output = 65536;
          };
        };
        "Qwen/Qwen3.8-27B-Vision" = qwen-opencode-config // {
          name = "Qwen3.8-27B (local, IQ4_XS, offloaded vision)";
          limit = {
            context = 65536;
            output = 32768;
          };
        };
        "Qwen/Qwen3.8-27B-FFN@IQ3_S" = qwen-opencode-config // {
          name = "Qwen3.8-27B (local, IQ4_XS, IQ3_S FFN)";
          limit = {
            context = 100096;
            output = 65536;
          };
        };
        "Meta/Muse-Glimmer-30B" = {
          name = "Meta/Muse-Glimmer-30B (local)";
          limit = {
            context = 131072;
            output = 65536;
          };
          modalities = {
            input = [
              "text"
              "audio"
              "image"
              "video"
              "pdf"
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
