# aerotheme-module.nix
{ config, pkgs, lib, ... }:

let
  aero = pkgs.qt6.callPackage ./aero2.nix {};
in
{
  options.services.aero = {
    enable = lib.mkEnableOption "Enable Aero";
    enableApplyService = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable oneshot service that runs the packaged 'apply' helper to apply libplasma patches.";
    };
  };

  config = lib.mkIf config.services.aero.enable {
    # expose packages on the system profile
    environment.systemPackages = [
      aero.libplasma
      aero.kwin
    ];

    environment.pathsToLink = [
      "/share"
      "/lib"
    ];

    systemd.services.apply-libplasma-patches = lib.mkIf config.services.aero.enableApplyService {
      description = "Apply libplasma patches for Aero (oneshot)";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${aero.libplasma}/dist/apply || echo \"apply helper missing\"; exit 0'";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    # User-level service to register KWin components (runs in user session)
    systemd.user.services.aero-register-kwin = lib.mkIf config.services.aero.enableApplyService {
      description = "Register Aero KWin components for user (oneshot at login)";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${aero.kwin}/bin/aero-register || echo \"aero-register missing or failed\"; exit 0'";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
