# Source: https://gitgud.io/aean0x/aerothemeplasma/-/blob/f4edc9ff83f3fcfb5ebbbd9872795a30f01c06e6/nix/aerothemeplasma.nix
{ pkgs, lib, stdenv, ... }:
let
  repo = pkgs.fetchFromGitHub {
    owner = "DuCanhGH";
    repo = "aerothemeplasma";
    rev = "9db1309865203899c66f8d4490a19065d765856b";
    hash = "sha256-9coWEif9xY53SRRjpYbQjzGQBGv1aJFeKTPSED+9V+Y=";
  };
  commonCmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_KF6=ON"
    # If using Wayland
    # "-DKWIN_BUILD_WAYLAND=ON"
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DKDE_INSTALL_PLUGINDIR=lib/qt-6/plugins"
    "-DKDE_INSTALL_QMLDIR=lib/qt-6/qml"
    "-DKWIN_INCLUDE=${pkgs.kdePackages.kwin-x11.dev}/include/kwin"
    "-DKPLUGINFACTORY_INCLUDE=${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons"
    ''-DCMAKE_CXX_FLAGS="-I${pkgs.kdePackages.kwin-x11.dev}/include/kwin -I${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons -I${pkgs.kdePackages.libplasma.dev}/include/Plasma -I${pkgs.kdePackages.libplasma.dev}/include/PlasmaQuick"''
    "-DKWin_DIR=${pkgs.kdePackages.kwin-x11.dev}/lib/cmake/KWin"
  ];
  mkAeroDerivation = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;

    extendDrvArgs = final: args @ {
      pname,
      version ? "0.0.1",
      src,
      cmakeFlags ? [],
      configurePhase ? ''cmake -B build -G Ninja ${lib.concatStringsSep " " (commonCmakeFlags ++ cmakeFlags)}'',
      buildPhase ? "ninja -C build",
      installPhase ? "ninja install -C build",
      nativeBuildInputs ? [],
      buildInputs ? [],
      ...
    }: let
      defaultNative = with pkgs; [
        cmake
        ninja
        kdePackages.extra-cmake-modules
        kdePackages.wrapQtAppsHook
        pkg-config
      ];
      defaultBuild = with pkgs; [
        kdePackages.qtbase
        kdePackages.qttools
        kdePackages.qtwayland
        kdePackages.qtdeclarative
        kdePackages.qtvirtualkeyboard
        kdePackages.qtmultimedia
        kdePackages.qt5compat
        kdePackages.qtstyleplugin-kvantum
        kdePackages.kconfig
        kdePackages.kcoreaddons
        kdePackages.kwindowsystem
        kdePackages.kcmutils
        kdePackages.kdecoration
        kdePackages.kconfigwidgets
        kdePackages.kcolorscheme
        # kdePackages.kwayland
        # kdePackages.kwin
        kdePackages.kwin-x11
        kdePackages.ksvg
        # kdePackages.plasma-wayland-protocols
        kdePackages.kguiaddons
        kdePackages.ki18n
        kdePackages.kiconthemes
        kdePackages.kirigami
        kdePackages.libplasma
      ];
    in
      args
      // {
        nativeBuildInputs = defaultNative ++ nativeBuildInputs;
        buildInputs = defaultBuild ++ buildInputs;

        inherit pname version src;

        configurePhase = ''
          runHook preConfigure
          ${configurePhase}
          runHook postConfigure
        '';
        buildPhase = ''
          runHook preBuild
          ${buildPhase}
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          ${installPhase}
          runHook postInstall
        '';
      };
  };
  decoration = pkgs.callPackage ./decoration.nix  {
    inherit mkAeroDerivation repo;
  };
in  {
  inherit repo mkAeroDerivation decoration;
  aeroglassblur = pkgs.callPackage ./aeroglassblur.nix  {
    inherit mkAeroDerivation repo decoration;
  };
  aeroglide = pkgs.callPackage ./aeroglide.nix  {
    inherit mkAeroDerivation repo decoration;
  };
  aerothemeplasma = pkgs.callPackage ./aerothemeplasma.nix {
    inherit repo;
  };
  desktopcontainment = pkgs.callPackage ./desktopcontainment.nix  {
    inherit mkAeroDerivation repo commonCmakeFlags;
  };
  kcmloader = pkgs.callPackage ./kcmloader.nix  {
    inherit mkAeroDerivation repo;
  };
  notifications = pkgs.callPackage ./notifications.nix  {
    inherit mkAeroDerivation repo;
  };
  sevenstart = pkgs.callPackage ./sevenstart.nix  {
    inherit mkAeroDerivation repo;
  };
  seventasks = pkgs.callPackage ./seventasks.nix  {
    inherit mkAeroDerivation repo;
  };
  smodglow = pkgs.callPackage ./smodglow.nix  {
    inherit mkAeroDerivation repo decoration;
  };
  smodsnap = pkgs.callPackage ./smodsnap.nix  {
    inherit mkAeroDerivation repo decoration;
  };
  startupfeedback = pkgs.callPackage ./startupfeedback.nix  {
    inherit mkAeroDerivation repo decoration;
  };
  systemtray = pkgs.callPackage ./systemtray.nix  {
    inherit mkAeroDerivation repo;
  };
}