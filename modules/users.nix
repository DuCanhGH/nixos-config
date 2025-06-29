{ pkgs, ... }: {
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
    useUserPackages = true;
    users = {
      ducanh = import ../home/ducanh.nix;
    };
  };
}