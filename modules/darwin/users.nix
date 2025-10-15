{ inputs, pkgs, lib, ... }: {
  # Define a user account.
  users = {
    knownUsers = [ "ducanh" ];
    users = {
      ducanh = {
        name = "ducanh";
        home = "/Users/ducanh";
        uid = 501;
        shell = pkgs.fish;
        packages = with pkgs; [
          tree
        ];
      };
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
          homeDirectory = "/Users/ducanh";
        };
        programs.firefox = {
          enable = true;
        };
      };
    };
  };
}