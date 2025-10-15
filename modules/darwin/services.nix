{ pkgs, ... }: {
  # List services that you want to enable:
  services.postgresql = {
    enable = true;
    ensureDatabases = [ ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}