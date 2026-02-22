{
  pkgs,
  mkAeroDerivation,
  decoration,
}:

mkAeroDerivation {
  pname = "aero-smodglow";
  buildInputs = [
    decoration
  ];
  src = "${pkgs.aero-smod-repo}/smodglow";
}
