{
  pkgs,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-kcmloader";
  src = "${aero.dev}/plasma/aerothemeplasma-kcmloader";
  buildInputs = [
    pkgs.kdePackages.kcmutils
  ];
}
