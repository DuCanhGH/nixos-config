{
  pkgs,
  lib,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-desktopcontainment";
  src = "${aero.dev}/plasma/plasmoids/desktopcontainment";
  buildInputs = with pkgs.kdePackages; [
    knotifyconfig
    krunner
    ksvg
    plasma-activities
    plasma-activities-stats
    plasma5support
  ];
  postPatch = "substituteInPlace CMakeLists.txt --replace-fail 'ecm_find_qmlmodule(org.kde.kirigami REQUIRED)' ''";
}
