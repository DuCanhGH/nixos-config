{ mkAeroDerivation, repo, decoration }:

mkAeroDerivation {
  pname = "aeroglassblur";
  buildInputs = [
    decoration
  ];
  src = "${repo}/kwin/effects_cpp/kde-effects-aeroglassblur";
}