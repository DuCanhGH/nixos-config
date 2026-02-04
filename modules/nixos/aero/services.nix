{ config, pkgs, lib, ... }: {
  options.services.aero = {
    enable = lib.mkEnableOption "Enable Aero";
  };

  config = lib.mkIf config.services.aero.enable {
    environment.variables = {
      QT_PLUGIN_PATH = [ "${pkgs.aero.aerothemeplasma}/lib/qt-6/plugins" "${pkgs.aero.decoration}/lib/qt-6/plugins" ];
      QML2_IMPORT_PATH = "${pkgs.kdePackages.libplasma}/lib/qt-6/qml:${pkgs.aero.aerothemeplasma}/lib/qt-6/qml:$QML2_IMPORT_PATH";
      QML_DISABLE_DISTANCEFIELD = "1";
    };

    environment.systemPackages = (with pkgs.aero; [
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
    ]) ++ (with pkgs; [
      kdePackages.qtbase
      # kdePackages.qtwayland
      kdePackages.qtdeclarative
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
      kdePackages.qt5compat
      kdePackages.qtstyleplugin-kvantum
      kdePackages.sddm-kcm
      # kdePackages.kwayland
      kdePackages.kitemmodels
      kdePackages.kde-gtk-config
      kdePackages.plasma5support
      kdePackages.polkit-kde-agent-1
      xdg-desktop-portal-gtk
      # kdePackages.plasma-wayland-protocols
    ]);

    services.displayManager.sddm = {
      theme = "sddm-theme-mod";
      settings = {
        Theme = {
          CursorTheme = "aero-drop";
        };
      };
    };

    services.displayManager.defaultSession = "aerothemeplasma";

    services.displayManager.sessionPackages = [ pkgs.aero.login-sessions ];

    fonts.packages = with pkgs; [
      corefonts
      vista-fonts
    ];
  };
}