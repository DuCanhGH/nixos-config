{ mkAeroDerivation, repo, decoration }:

mkAeroDerivation {
  pname = "aeroglide";
  buildInputs = [
    decoration
  ];
  src = "${repo}/kwin/effects_cpp/aeroglide";
}