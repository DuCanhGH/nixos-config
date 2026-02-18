{
  pkgs,
  lib,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-desktopcontainment";
  src = "${aero.dev}/plasma/plasmoids/desktopcontainment";
  buildInputs = with pkgs; [
    kdePackages.knotifyconfig
    kdePackages.krunner
    kdePackages.ksvg
    kdePackages.plasma-activities
    kdePackages.plasma-activities-stats
  ];
  postPatch = "substituteInPlace CMakeLists.txt --replace-fail 'ecm_find_qmlmodule(org.kde.kirigami REQUIRED)' ''";
}
