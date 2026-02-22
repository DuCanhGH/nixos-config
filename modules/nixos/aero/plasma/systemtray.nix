{
  pkgs,
  mkAeroDerivation,
  aero
}:

mkAeroDerivation {
  pname = "aero-systemtray";
  buildInputs = with pkgs; [
    kdePackages.qtwayland
    kdePackages.knotifyconfig
    kdePackages.kstatusnotifieritem
    kdePackages.kitemmodels
  ];
  src = "${aero.dev}/plasma/plasmoids/systemtray_src";
}
