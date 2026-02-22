{
  pkgs,
  mkAeroDerivation,
  aeroEffects,
  smod,
}:

mkAeroDerivation {
  pname = "aero-startupfeedback";
  buildInputs = [
    smod
  ];
  src = "${aeroEffects}/startupfeedback";
}
