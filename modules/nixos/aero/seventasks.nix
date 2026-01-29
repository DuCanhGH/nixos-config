{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "seventasks";
  src = "${repo}/plasma/plasmoids/src/seventasks_src";
}