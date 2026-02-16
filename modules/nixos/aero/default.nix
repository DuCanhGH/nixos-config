# Source: https://gitgud.io/aean0x/aerothemeplasma/-/blob/f4edc9ff83f3fcfb5ebbbd9872795a30f01c06e6/nix/aerothemeplasma.nix
{
  waylandEnabled ? false,
  pkgs,
  lib,
  stdenv,
  ...
}:
let
  repo = pkgs.aero-repo;
  libplasma = pkgs.callPackage ./libplasma.nix {
    inherit repo;
  };
  commonCmakeFlags = ([
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_KF6=ON"
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DKDE_INSTALL_PLUGINDIR=lib/qt-6/plugins"
    "-DKDE_INSTALL_QMLDIR=lib/qt-6/qml"
    "-DKPLUGINFACTORY_INCLUDE=${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons"
  ])
  ++ (
    if waylandEnabled then
      [
        "-DKWIN_BUILD_WAYLAND=ON"
        "-DKWIN_INCLUDE=${pkgs.kdePackages.kwin.dev}/include/kwin"
        "-DKWin_DIR=${pkgs.kdePackages.kwin.dev}/lib/cmake/KWin"
        ''-DCMAKE_CXX_FLAGS="-I${pkgs.kdePackages.kwin.dev}/include/kwin -I${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons -I${libplasma.dev}/include/Plasma -I${libplasma.dev}/include/PlasmaQuick"''
      ]
    else
      [
        "-DKWIN_INCLUDE=${pkgs.kdePackages.kwin-x11.dev}/include/kwin"
        "-DKWin_DIR=${pkgs.kdePackages.kwin-x11.dev}/lib/cmake/KWin"
        ''-DCMAKE_CXX_FLAGS="-I${pkgs.kdePackages.kwin-x11.dev}/include/kwin -I${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons -I${libplasma.dev}/include/Plasma -I${libplasma.dev}/include/PlasmaQuick"''
      ]
  );
  mkAeroDerivation = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;

    extendDrvArgs =
      final:
      args@{
        pname,
        version ? repo.rev,
        src,
        cmakeFlags ? [ ],
        configurePhase ? "cmake -B build -G Ninja ${
          lib.concatStringsSep " " (commonCmakeFlags ++ cmakeFlags)
        }",
        buildPhase ? "ninja -C build",
        installPhase ? "ninja install -C build",
        nativeBuildInputs ? [ ],
        buildInputs ? [ ],
        ...
      }:
      let
        defaultNative = with pkgs; [
          cmake
          ninja
          kdePackages.extra-cmake-modules
          kdePackages.wrapQtAppsHook
          pkg-config
        ];
        defaultBuild =
          (with pkgs; [
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
            kdePackages.ksvg
            kdePackages.kguiaddons
            kdePackages.ki18n
            kdePackages.kiconthemes
            kdePackages.kirigami
            kdePackages.libplasma
            kdePackages.plasma5support
            kdePackages.plasma-workspace
          ])
          ++ (
            if waylandEnabled then
              with pkgs;
              [
                kdePackages.kwin
                kdePackages.kwayland
                kdePackages.plasma-wayland-protocols
              ]
            else
              with pkgs;
              [
                kdePackages.kwin-x11
              ]
          );
      in
      args
      // {
        inherit pname version src;
        nativeBuildInputs = defaultNative ++ nativeBuildInputs;
        buildInputs = defaultBuild ++ buildInputs;
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
  aero = pkgs.callPackage ./aerothemeplasma.nix {
    inherit repo;
  };
  decoration = pkgs.callPackage ./decoration.nix {
    inherit mkAeroDerivation aero;
  };
in
{
  inherit
    repo
    mkAeroDerivation
    decoration
    libplasma
    ;
  aerothemeplasma = aero;
  aerofonts = pkgs.callPackage ./aerofonts.nix { };
  aeroglassblur = pkgs.callPackage ./aeroglassblur.nix {
    inherit mkAeroDerivation aero decoration;
  };
  aeroglide = pkgs.callPackage ./aeroglide.nix {
    inherit mkAeroDerivation aero decoration;
  };
  desktopcontainment = pkgs.callPackage ./desktopcontainment.nix {
    inherit mkAeroDerivation aero commonCmakeFlags;
  };
  kcmloader = pkgs.callPackage ./kcmloader.nix {
    inherit mkAeroDerivation aero;
  };
  login-sessions = pkgs.callPackage ./login-sessions.nix {
    inherit mkAeroDerivation aero libplasma;
  };
  notifications = pkgs.callPackage ./notifications.nix {
    inherit mkAeroDerivation aero;
  };
  sevenstart = pkgs.callPackage ./sevenstart.nix {
    inherit mkAeroDerivation aero;
  };
  seventasks = pkgs.callPackage ./seventasks.nix {
    inherit mkAeroDerivation aero;
  };
  smodglow = pkgs.callPackage ./smodglow.nix {
    inherit mkAeroDerivation aero decoration;
  };
  smodsnap = pkgs.callPackage ./smodsnap.nix {
    inherit mkAeroDerivation aero decoration;
  };
  startupfeedback = pkgs.callPackage ./startupfeedback.nix {
    inherit mkAeroDerivation aero decoration;
  };
  systemtray = pkgs.callPackage ./systemtray.nix {
    inherit mkAeroDerivation aero;
  };
}
