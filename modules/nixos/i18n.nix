{ pkgs, lib, ... }: {
  # Set your time zone.
  time.timeZone = lib.mkDefault "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-bamboo ];
      waylandFrontend = true;

      settings.inputMethod = {
        "Groups/0" = {
          "Name" = "Default";
          "Default Layout" = "us-altgr-intl";
          "DefaultIM" = "keyboard-us-altgr-intl";
        };
        "Groups/0/Items/0" = { "Name" = "keyboard-us-altgr-intl"; };
        "Groups/0/Items/1" = { "Name" = "bamboo"; };
      };
    };
  };
}