{ pkgs, mkAeroDerivation, aero }:

mkAeroDerivation {
  pname = "aero-notifications";
  src = "${aero.dev}/plasma/plasmoids/notifications_src/";
  buildInputs = with pkgs.kdePackages; [
    plasma-workspace
    knotifyconfig
  ];
}
