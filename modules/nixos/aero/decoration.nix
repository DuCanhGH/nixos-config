{ mkAeroDerivation, aero }:

mkAeroDerivation {
  pname = "aero-decoration";
  src = "${aero.dev}/kwin/decoration";
}
