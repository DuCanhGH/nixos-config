{
  mkAeroDerivation,
  aero,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-smodglow";
  buildInputs = [
    decoration
  ];
  src = "${aero.dev}/kwin/effects/smodglow";
}
