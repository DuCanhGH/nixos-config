{
  pkgs,
  mkAeroDerivation,
  mkBuildTarget,
  smod,
}:

mkAeroDerivation {
  pname = "aeroglide";
  buildInputs = [
    smod
    pkgs.wayland-protocols
  ];
  src = pkgs.repos.aero-kwin;
  ninjaFlags = [ "${mkBuildTarget "aeroglide"}" ];
}
