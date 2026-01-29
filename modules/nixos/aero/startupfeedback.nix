{ mkAeroDerivation, repo, decoration }:

mkAeroDerivation {
  pname = "aero-startupfeedback";
  buildInputs = [
    decoration
  ];
  src = "${repo}/kwin/effects_cpp/startupfeedback";
}