{
  mkAeroDerivation,
  aeroEffects,
  smod,
}:

mkAeroDerivation {
  pname = "aeroglide";
  buildInputs = [
    smod
  ];
  src = "${aeroEffects}/aeroglide";
}
