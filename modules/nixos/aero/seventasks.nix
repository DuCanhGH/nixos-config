{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-seventasks";
  src = "${repo}/plasma/plasmoids/src/seventasks_src";
}