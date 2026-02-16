{
  pkgs,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-sevenstart";
  src = "${aero.dev}/plasma/plasmoids/sevenstart_src";
}
