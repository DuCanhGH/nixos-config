{
  pkgs,
  mkAeroDerivation,
  aeroEffects,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-startupfeedback";
  buildInputs = [
    decoration
  ];
  src = "${aeroEffects}/startupfeedback";
}
