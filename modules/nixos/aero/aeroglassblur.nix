{
  mkAeroDerivation,
  aero,
  decoration,
}:

mkAeroDerivation {
  pname = "aeroglassblur";
  buildInputs = [
    decoration
  ];
  src = "${aero.dev}/kwin/effects/kde-effects-aeroglassblur";
}
