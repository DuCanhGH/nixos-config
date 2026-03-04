{
  pkgs,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-kcmloader";
  src = "${pkgs.repos.aero-workspace}/aeroshell-kcmloader";
  buildInputs = with pkgs.kdePackages; [
    kcmutils
  ];
}
