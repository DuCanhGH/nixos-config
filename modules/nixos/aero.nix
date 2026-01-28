{ pkgs, qtbase, wrapQtAppsHook, ... }:

pkgs.stdenv.mkDerivation {
  pname = "aero";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "WackyIdeas";
    repo = "aerothemeplasma";
    rev = "9c9d4f2a4e84319351428b8b13f84eb0eb4e2ada";
    hash = "sha256-fXxNDNm5dFRr5g3k0alEsoc83wyKMIt9Ud/yFOCT3II=";
  };

  buildInputs = with pkgs; [
    qtbase
  ];

  nativeBuildInputs = with pkgs; [
    bash
    python314Packages.cmake
    python314Packages.ninja
    kdePackages.extra-cmake-modules
    kdePackages.qtvirtualkeyboard
    kdePackages.qtmultimedia
    kdePackages.qt5compat
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
    kdePackages.sddm
    kdePackages.sddm-kcm
    kdePackages.plasma-wayland-protocols
    kdePackages.plasma5support
    wrapQtAppsHook
  ];

  configurePhase = ''
    runHook preConfigure
    mkdir -p build
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    sh compile.sh --ninja
    sh install_plasmoids.sh --ninja
    sh install_kwin_components.sh
    sh install_plasma_components.sh
    sh install_misc_components.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  enableParallelBuilding = true;
}