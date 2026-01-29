{ inputs, pkgs, ... }:
let
  aero = pkgs.callPackage ./aero {};
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    ducanh = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        tree
      ];
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users = {
      ducanh = {
        imports = [ ../../home/ducanh.nix ];
        home = {
          homeDirectory = "/home/ducanh";
          file = {
            ".local/share/plasma/desktoptheme".source = "${aero.repo}/plasma/desktoptheme";
            ".local/share/plasma/look-and-feel".source = "${aero.repo}/plasma/look-and-feel";
            ".local/share/plasma/plasmoids".source = "${aero.repo}/plasma/plasmoids";
            ".local/share/plasma/layout-templates".source = "${aero.repo}/plasma/layout-templates";
            ".local/share/plasma/shells".source = "${aero.repo}/plasma/shells";
            ".local/share/kwin/effects".source = "${aero.repo}/kwin/effects";
            ".local/share/kwin/tabbox".source = "${aero.repo}/kwin/tabbox";
            ".local/share/kwin/outline".source = "${aero.repo}/kwin/outline";
            ".config/fontconfig/fonts.conf".source = "${aero.repo}/misc/fontconfig/fonts.conf";
            ".local/share/smod".source = "${aero.repo}/plasma/smod";
            ".local/share/sddm/themes/sddm-theme-mod".source = "${aero.repo}/plasma/sddm/sddm-theme-mod";
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
        };
      };
    };
  };
}