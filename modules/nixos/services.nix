{ pkgs, ... }: {
  # List services that you want to enable:

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Enable the KDE Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    settings.General.DisplayServer = "x11-user";
  };
  services.desktopManager.plasma6.enable = true;
  services.aero.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";
  services.btrfs.autoScrub.fileSystems = [ "/" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  services.cloudflare-warp.enable = true;

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "blisk" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}