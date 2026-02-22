{
  pkgs,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-kcmloader";
  src = "${pkgs.aero-workspace-repo}/aeroshell-kcmloader";
  buildInputs = [
    pkgs.kdePackages.kcmutils
  ];
}
