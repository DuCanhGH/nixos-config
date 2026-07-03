{
  pkgs,
  mkAeroDerivation,
  smod,
}:

mkAeroDerivation {
  pname = "aero-smodsnap";
  buildInputs = [
    smod
    pkgs.wayland-protocols
  ];
  src = pkgs.repos.aero-kwin;
  ninjaFlags = [ "kwin_effect_smodsnap" ];
}
