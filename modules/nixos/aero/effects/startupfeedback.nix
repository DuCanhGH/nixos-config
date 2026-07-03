{
  pkgs,
  mkAeroDerivation,
  mkBuildTarget,
  smod,
}:

mkAeroDerivation {
  pname = "aero-startupfeedback";
  buildInputs = [
    smod
    pkgs.wayland-protocols
  ];
  src = pkgs.repos.aero-kwin;
  ninjaFlags = [ "${mkBuildTarget "launchfeedback"}" ];
}
