{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-notifications";
  src = "${repo}/plasma/plasmoids/src/notifications_src/";
}