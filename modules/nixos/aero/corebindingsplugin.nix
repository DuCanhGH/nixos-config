{ pkgs, mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "corebindingsplugin";
  src = pkgs.kdePackages.libplasma.src;
  postUnpack = ''
  '';
  buildPhase = ''
    ninja -C build corebindingsplugin
  '';
}