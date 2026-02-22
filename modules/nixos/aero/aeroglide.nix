{
  mkAeroDerivation,
  aeroEffects,
  decoration,
}:

mkAeroDerivation {
  pname = "aeroglide";
  buildInputs = [
    decoration
  ];
  src = "${aeroEffects}/aeroglide";
}
