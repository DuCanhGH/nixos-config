{
  mkAeroDerivation,
  aeroEffects,
  smod,
}:

mkAeroDerivation {
  pname = "aero-smodsnap";
  buildInputs = [
    smod
  ];
  src = "${aeroEffects}/kwin-effect-smodsnap-v2";
}
