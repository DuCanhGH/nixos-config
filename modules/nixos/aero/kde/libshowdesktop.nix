{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-libshowdesktop";
  src = pkgs.aero-workspace-repo;
  ninjaFlags = [ "showdesktopplugin" ];
  installPhase = ''
    runHook preInstall
    ninja libshowdesktop/install
    runHook postInstall
  '';
}
