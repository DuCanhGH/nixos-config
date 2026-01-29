{ config, pkgs, lib, ... }:

let
  aero = pkgs.callPackage ./default.nix {};
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
    environment.variables = {
      QT_PLUGIN_PATH = [ "${aero.aerothemeplasma}/lib/qt-6/plugins" "${aero.decoration}/lib/qt-6/plugins" ];
      QML2_IMPORT_PATH = "${aero.aerothemeplasma}/lib/qt-6/qml:$QML2_IMPORT_PATH";
      QML_DISABLE_DISTANCEFIELD = "1";
    };

    environment.systemPackages = (with aero; [
      aeroglassblur
      aeroglide
      aerothemeplasma
      corebindingsplugin
      decoration
      desktopcontainment
      sevenstart
      seventasks
      smodglow
      smodsnap
      startupfeedback
    ]) ++ (with pkgs; [
      kdePackages.qtbase
      kdePackages.qtwayland
      kdePackages.qtdeclarative
      kdePackages.qtvirtualkeyboard
      kdePackages.qtmultimedia
      kdePackages.qt5compat
      kdePackages.qtstyleplugin-kvantum
      kdePackages.kwayland
      kdePackages.plasma5support
      kdePackages.plasma-wayland-protocols
      kdePackages.plasma5support
    ]);

    services.displayManager.sddm = {
      theme = "sddm-theme-mod";
      settings = {
        Theme = {
          CursorTheme = "aero-drop";
        };
      };
    };

    fonts = {
      packages = with pkgs; [
        corefonts
        vista-fonts
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["Segoe UI"];
          serif = ["Segoe UI"];
          monospace = ["Hack"];
        };
      };
    };
  };
}