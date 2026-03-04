{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-libshowdesktop";
  src = pkgs.repos.aero-workspace;
  ninjaFlags = [ "showdesktopplugin" ];
  buildInputs = with pkgs.kdePackages; [
    libksysguard
    plasma-workspace
  ];
  installPhase = ''
    runHook preInstall
    ninja libshowdesktop/install
    runHook postInstall
  '';
}
