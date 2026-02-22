{
  mkAeroDerivation,
  aeroEffects,
  smod,
}:

mkAeroDerivation {
  pname = "aeroglassblur";
  buildInputs = [
    smod
  ];
  src = "${aeroEffects}/kde-effects-aeroglassblur";
}
