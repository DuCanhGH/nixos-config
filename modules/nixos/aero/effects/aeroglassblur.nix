{
  pkgs,
  mkAeroDerivation,
  mkBuildTarget,
  smod,
}:

mkAeroDerivation {
  pname = "aeroglassblur";
  buildInputs = [
    smod
    pkgs.wayland-protocols
  ];
  src = pkgs.repos.aero-kwin;
  ninjaFlags = [ "${mkBuildTarget "aeroglassblur"}" ];
}
