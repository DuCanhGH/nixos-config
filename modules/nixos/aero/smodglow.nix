{ mkAeroDerivation, repo, decoration }:

mkAeroDerivation {
  pname = "aero-smodglow";
  buildInputs = [
    decoration
  ];
  src = "${repo}/kwin/effects_cpp/smodglow";
}