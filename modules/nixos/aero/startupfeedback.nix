{
  mkAeroDerivation,
  aero,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-startupfeedback";
  buildInputs = [
    decoration
  ];
  src = "${aero.dev}/kwin/effects/startupfeedback";
}
