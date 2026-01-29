{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-kcmloader";
  src = "${repo}/plasma/aerothemeplasma-kcmloader";
}