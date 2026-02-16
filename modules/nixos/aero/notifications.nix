{ mkAeroDerivation, aero }:

mkAeroDerivation {
  pname = "aero-notifications";
  src = "${aero.dev}/plasma/plasmoids/notifications_src/";
}
