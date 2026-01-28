{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    (import ../shared/packages.nix { inherit pkgs; }) ++ (with pkgs; [
      chromium
      sbctl
      nurl
      unzip
      kdePackages.sddm
      kdePackages.sddm-kcm
      inputs.agenix.packages.x86_64-linux.default
    ]);

  # environment.gnome.excludePackages = with pkgs; [
  #   cheese      # photo booth
  #   epiphany    # web browser
  #   gedit       # text editor
  #   simple-scan # document scanner
  #   totem       # video player
  #   yelp        # help viewer
  #   evince      # document viewer
  #   file-roller # archive manager
  #   geary       # email client
  #   tali        # poker game
  #   iagno       # go game
  #   hitori      # sudoku game
  #   atomix      # puzzle game
  #   gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
  #   gnome-font-viewer gnome-logs gnome-maps gnome-music gnome-photos gnome-terminal
  #   gnome-system-monitor gnome-weather gnome-disk-utility gnome-connections gnome-tour
  # ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.nix-ld.enable = true;

  programs.fish.enable = true;

  programs.firefox.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.sudo.extraConfig = ''
    Defaults    env_keep+=SSH_AUTH_SOCK
  '';

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.auto-optimise-store = true;
    optimise.automatic = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}