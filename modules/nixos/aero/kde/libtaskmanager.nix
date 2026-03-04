{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-libtaskmanager";
  src = pkgs.repos.aero-workspace;
  ninjaFlags = [ "taskmanagerplugin" ];
  buildInputs = with pkgs.kdePackages; [
    libksysguard
    plasma-workspace
  ];
  installPhase = ''
    runHook preInstall
    ninja libtaskmanager/install
    runHook postInstall
  '';
}
