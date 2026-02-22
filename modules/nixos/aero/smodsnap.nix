{
  mkAeroDerivation,
  aeroEffects,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-smodsnap";
  buildInputs = [
    decoration
  ];
  src = "${aeroEffects}/kwin-effect-smodsnap-v2";
}
