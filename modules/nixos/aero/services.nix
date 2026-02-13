{
  config,
  pkgs,
  lib,
  ...
}:
let
  plymouth-vista = pkgs.callPackage ./plymouth.nix { };
in
{
  options.services.aero = {
    enable = lib.mkEnableOption "Enable Aero";
    wayland.enable = lib.mkEnableOption "Enable Wayland";
    plymouth.enable = lib.mkEnableOption "Enable Plymouth Vista";
  };

  config = lib.mkIf config.services.aero.enable {
    boot.plymouth = lib.mkIf config.services.aero.plymouth.enable {
      theme = "plymouth-vista";
      themePackages = [
        plymouth-vista
      ];
      extraConfig = ''
        UseSimpledrm = 1
      '';
    };

    systemd.services.plymouth-quit.serviceConfig = {
      ExecStartPre = [ "${pkgs.coreutils}/bin/sleep 10" ];
    };

    environment.variables = {
      QT_PLUGIN_PATH = [
        "${pkgs.aero.aerothemeplasma}/lib/qt-6/plugins"
        "${pkgs.aero.decoration}/lib/qt-6/plugins"
      ];
      QML2_IMPORT_PATH = "${pkgs.kdePackages.libplasma}/lib/qt-6/qml:${pkgs.aero.aerothemeplasma}/lib/qt-6/qml:$QML2_IMPORT_PATH";
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
        notifications
        sevenstart
        seventasks
        smodglow
        smodsnap
        startupfeedback
        systemtray
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
        if config.services.aero.wayland.enable then
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
      wayland.enable = config.services.aero.wayland.enable;
      theme = "sddm-theme-mod";
      settings = {
        General = {
          DisplayServer = lib.mkIf config.services.aero.wayland.enable "wayland";
        };
        Theme = {
          CursorTheme = "aero-drop";
        };
      };
    };

    services.displayManager.defaultSession =
      if config.services.aero.wayland.enable then "aerothemeplasma-wayland" else "aerothemeplasma";

    services.displayManager.sessionPackages = [ pkgs.aero.login-sessions ];

    fonts.packages = with pkgs; [
      corefonts
      vista-fonts
    ];
  };
}
