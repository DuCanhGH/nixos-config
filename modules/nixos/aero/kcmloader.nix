{ mkAeroDerivation, aero }:

mkAeroDerivation {
  pname = "aero-kcmloader";
  src = "${aero.dev}/plasma/aerothemeplasma-kcmloader";
}
