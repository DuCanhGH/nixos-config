{
  mkAeroDerivation,
  aero,
  decoration,
}:

mkAeroDerivation {
  pname = "aeroglide";
  buildInputs = [
    decoration
  ];
  src = "${aero.dev}/kwin/effects/aeroglide";
}
