{
  mkAeroDerivation,
  aeroEffects,
  decoration,
}:

mkAeroDerivation {
  pname = "aeroglassblur";
  buildInputs = [
    decoration
  ];
  src = "${aeroEffects}/kde-effects-aeroglassblur";
}
