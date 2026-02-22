{ mkAeroDerivation, aero }:

mkAeroDerivation {
  pname = "aero-seventasks";
  src = "${aero.dev}/plasma/plasmoids/seventasks_src";
}
