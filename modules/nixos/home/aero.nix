{ config, lib, pkgs, ... }: {
  options.aero.enable = lib.mkEnableOption "Enable Aero user configuration";
  config = lib.mkIf config.aero.enable {
    home.file = {
      ".local/share/color-schemes".source = "${pkgs.aero.aerothemeplasma}/share/color_scheme";
      ".local/share/plasma/desktoptheme".source = "${pkgs.aero.aerothemeplasma}/share/plasma/desktoptheme";
      ".local/share/plasma/look-and-feel".source = "${pkgs.aero.aerothemeplasma}/share/plasma/look-and-feel";
      ".local/share/plasma/plasmoids".source = "${pkgs.aero.aerothemeplasma}/share/plasma/plasmoids";
      ".local/share/plasma/layout-templates".source = "${pkgs.aero.aerothemeplasma}/share/plasma/layout-templates";
      ".local/share/kwin/effects".source = "${pkgs.aero.aerothemeplasma}/share/kwin/effects";
      ".local/share/kwin/outline".source = "${pkgs.aero.aerothemeplasma}/share/kwin/outline";
      ".local/share/kwin/tabbox".source = "${pkgs.aero.aerothemeplasma}/share/kwin/tabbox";
      ".local/share/kwin-x11/effects".source = "${pkgs.aero.aerothemeplasma}/share/kwin/effects";
      ".local/share/kwin-x11/outline".source = "${pkgs.aero.aerothemeplasma}/share/kwin/outline";
      ".local/share/kwin-x11/tabbox".source = "${pkgs.aero.aerothemeplasma}/share/kwin/tabbox";
      ".local/share/kwin-wayland/effects".source = "${pkgs.aero.aerothemeplasma}/share/kwin/effects";
      ".local/share/kwin-wayland/outline".source = "${pkgs.aero.aerothemeplasma}/share/kwin/outline";
      ".local/share/kwin-wayland/tabbox".source = "${pkgs.aero.aerothemeplasma}/share/kwin/tabbox";
      ".local/share/smod".source = "${pkgs.aero.aerothemeplasma}/share/smod";
      ".config/Kvantum".source = "${pkgs.aero.aerothemeplasma}/share/Kvantum";
    };
    fonts.fontconfig = {
      enable = true;
      hinting = "full";
      defaultFonts = {
        sansSerif = ["Segoe UI"];
        serif = ["Segoe UI"];
        monospace = ["Hack"];
      };
    };
    programs.plasma = {
      enable = true;
      shortcuts.kwin = {
        "MinimizeAll" = "Meta+D";
        "Peek at Desktop" = [];
        "Walk Through Windows Alternative" = "Meta+Tab";
      };
      configFile = {
        "kwinrc"."TabBox" = {
          "LayoutName" = "thumbnail_seven";
          "ShowDesktopMode" = 1;
        };
        "kwinrc"."TabBoxAlternative" = {
          "LayoutName" = "flipswitch";
        };
        "kwinrc"."MouseBindings"."CommandWheel" = "Nothing";
        "kwinrc"."Plugins" = {
          "kwin4_effect_aeroglassblurEnabled" = true;
          "kwin4_effect_aeroglideEnabled" = true;
          "smodsnapEnabled" = true;
          "smodglowEnabled" = true;
          "startupfeedbackEnabled" = true;
          "desaturateUnresponsiveAppsEnabled" = true;
          "fadingPopupsEnabled" = true;
          "loginEnabled" = true;
          "squashEnabled" = true;
          "smodpeekeffectEnabled" = true;
          "dimScreenForAdminModeEnabled" = true;
          "minimizeallEnabled" = true;
          "dimscreenEnabled" = true;
          "backgroundcontrastEnabled" = false;
          "blurEnabled" = false;
          "maximizeEnabled" = false;
          "slidingpopupsEnabled" = false;
          "dialogparentEnabled" = false;
          "diminactiveEnabled" = false;
          "logoutEnabled" = false;
        };
        "kwinrc"."Scripts" = {
          "minimizeall" = true;
          "smodpeekscript" = true;
        };
        "ksmserverrc"."General"."confirmLogout" = false;
        "kcminputrc"."Mouse"."BusyCursor" = "none";
        "klaunchrc"."FeedbackStyle"."BusyCursor" = false;
        "kdeglobals"."General" = {
          "font" = "Segoe UI,9,-1,5,50,0,0,0,0,0";
          "menuFont" = "Segoe UI,9,-1,5,50,0,0,0,0,0";
          "toolBarFont" = "Segoe UI,9,-1,5,50,0,0,0,0,0";
          "smallestReadableFont" = "Segoe UI,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        };
        "kdeglobals"."General"."accentColorFromWallpaper" = false;
      };
      window-rules = [
        {
          description = "POLKIT_RULES";
          match = {
            window-class = {
              value = "(polkit-kde-authentication-agent-1)|(polkit-kde-manager)|(org.kde.polkit-kde-authentication-agent-1)";
              type = "regex";
            };
            machine = {
              value = "localhost";
              type = "exact";
            };
          };
          apply = {
            minimize = {
              value = false;
              apply = "force";
            };
          };
        }
      ];
    };
  };
}