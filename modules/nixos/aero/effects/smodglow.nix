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
  src = "${pkgs.repos.aero-smod}/smodglow";
}
