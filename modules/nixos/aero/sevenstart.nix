{ pkgs, mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-sevenstart";
  src = "${repo}/plasma/plasmoids/src/sevenstart_src";
}