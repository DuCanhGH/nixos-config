{ pkgs, mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-systemtray";
  buildInputs = with pkgs; [
    kdePackages.knotifyconfig
    kdePackages.kstatusnotifieritem
    kdePackages.kitemmodels
  ];
  src = "${repo}/plasma/plasmoids/src/systemtray_src";
}