{
  pkgs,
  mkAeroDerivation,
  aero,
}:
mkAeroDerivation {
  pname = "aero-decoration";
  src = "${aero.dev}/kwin/decoration";
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
