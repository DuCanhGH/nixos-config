{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-decoration";
  src = "${repo}/kwin/decoration";
}