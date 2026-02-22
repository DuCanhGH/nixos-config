{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-libtaskmanager";
  src = pkgs.aero-workspace-repo;
  ninjaFlags = [ "taskmanagerplugin" ];
  installPhase = ''
    runHook preInstall
    ninja libtaskmanager/install
    runHook postInstall
  '';
}
