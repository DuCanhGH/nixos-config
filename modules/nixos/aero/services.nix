{
  config,
  pkgs,
  lib,
  ...
}:
let
  plymouth-vista = pkgs.callPackage ./plymouth.nix {
    inherit (pkgs.aero) aerofonts;
  };
  cfg = config.services.aero;
in
{
  options.services.aero = {
    enable = lib.mkEnableOption "Enable Aero";
    wayland.enable = lib.mkEnableOption "Enable Wayland";
    plymouth = {
      enable = lib.mkEnableOption "Enable Plymouth Vista";
      delay = lib.mkOption {
        default = 10;
        description = "Delay before quitting Plymouth";
        type = lib.types.nullOr lib.types.ints.unsigned;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.plymouth = lib.mkIf cfg.plymouth.enable {
      theme = "plymouth-vista";
      themePackages = [
        plymouth-vista
      ];
      extraConfig = ''
        UseSimpledrm = 1
      '';
    };

    systemd.services.plymouth-quit.serviceConfig = lib.mkIf (cfg.plymouth.delay != null) {
      ExecStartPre = [ "${pkgs.coreutils}/bin/sleep ${lib.toString cfg.plymouth.delay}" ];
    };

    environment.sessionVariables = {
      QML_DISABLE_DISTANCEFIELD = "1";
    };

    environment.systemPackages =
      (with pkgs.aero; [
        aerofonts
        aeroglassblur
        aeroglide
        aerothemeplasma
        decoration
        desktopcontainment
        kcmloader
        libplasma
        notifications
        sevenstart
        seventasks
        smodglow
        smodsnap
        startupfeedback
        systemtray
        (lib.hiPrio plasmashell)
      ])
      ++ (with pkgs; [
        kdePackages.qtbase
        kdePackages.qtdeclarative
        kdePackages.qtvirtualkeyboard
        kdePackages.qtmultimedia
        kdePackages.qt5compat
        kdePackages.qtstyleplugin-kvantum
        kdePackages.sddm-kcm
        kdePackages.kitemmodels
        kdePackages.kde-gtk-config
        kdePackages.plasma5support
        kdePackages.polkit-kde-agent-1
        xdg-desktop-portal-gtk
      ])
      ++ (
        if cfg.wayland.enable then
          with pkgs;
          [
            kdePackages.qtwayland
            kdePackages.kwayland
            kdePackages.plasma-wayland-protocols
          ]
        else
          [ ]
      );

    services.displayManager.sddm = {
      wayland.enable = cfg.wayland.enable;
      theme = "sddm-theme-mod";
      settings = {
        General = {
          DisplayServer = lib.mkIf cfg.wayland.enable "wayland";
        };
        Theme = {
          CursorTheme = "aero-drop";
        };
      };
    };

    services.displayManager.defaultSession =
      if cfg.wayland.enable then "aerothemeplasma-wayland" else "aerothemeplasma";

    services.displayManager.sessionPackages = [ pkgs.aero.login-sessions ];

    fonts.packages = with pkgs; [
      corefonts
      vista-fonts
    ];
  };
}
