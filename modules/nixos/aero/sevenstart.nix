{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "sevenstart";
  src = "${repo}/plasma/plasmoids/src/sevenstart_src";
}