{ mkAeroDerivation, repo, decoration }:

mkAeroDerivation {
  pname = "aero-smodsnap";
  buildInputs = [
    decoration
  ];
  src = "${repo}/kwin/effects_cpp/kwin-effect-smodsnap-v2";
}