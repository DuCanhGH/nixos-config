{
  mkAeroDerivation,
  aero,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-smodsnap";
  buildInputs = [
    decoration
  ];
  src = "${aero.dev}/kwin/effects/kwin-effect-smodsnap-v2";
}
