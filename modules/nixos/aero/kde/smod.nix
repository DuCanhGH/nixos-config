{
  pkgs,
  mkAeroDerivation,
  aero,
}:
mkAeroDerivation {
  pname = "aero-smod";
  src = pkgs.aero-smod-repo;
  buildInputs = with pkgs.kdePackages; [
    kirigami
    kcoreaddons
    kcolorscheme
    kguiaddons
    ki18n
    kiconthemes
    kwindowsystem
    kdecoration
    kcmutils
  ];
}
