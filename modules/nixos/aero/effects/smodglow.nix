{
  pkgs,
  mkAeroDerivation,
  smod,
}:

mkAeroDerivation {
  pname = "aero-smodglow";
  buildInputs = [
    smod
  ];
  src = "${pkgs.aero-smod-repo}/smodglow";
}
