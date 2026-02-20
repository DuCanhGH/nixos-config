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
  plasmashell = pkgs.callPackage ./plasmashell.nix {
    inherit libplasma;
  };
  commonCmakeFlags = ([
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_KF6=ON"
    "-DPlasma_DIR=${libplasma.dev}/lib/cmake/Plasma"
    "-DPlasmaQuick_DIR=${libplasma.dev}/lib/cmake/PlasmaQuick"
  ])
  ++ (lib.optionals waylandEnabled [
    "-DKWIN_BUILD_WAYLAND=ON"
  ]);
  # Source: https://github.com/Rotlug/aerothemeplasma-nixos/blob/8452aa903e76f9c20a62024c6d6f2c4be6933c8d/default.nix#L23-L70
  mkAeroDerivation = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;

    extendDrvArgs =
      final:
      args@{
        pname,
        version ? "0.0.1",
        src,
        cmakeFlags ? [ ],
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
        cmakeFlags = commonCmakeFlags ++ cmakeFlags;
        nativeBuildInputs = defaultNative ++ nativeBuildInputs;
        buildInputs = defaultBuild ++ buildInputs;
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
  inherit decoration libplasma plasmashell;
  aerothemeplasma = aero;
  aerofonts = pkgs.callPackage ./aerofonts.nix { };
  aeroglassblur = pkgs.callPackage ./aeroglassblur.nix {
    inherit mkAeroDerivation aero decoration;
  };
  aeroglide = pkgs.callPackage ./aeroglide.nix {
    inherit mkAeroDerivation aero decoration;
  };
  desktopcontainment = pkgs.callPackage ./desktopcontainment.nix {
    inherit mkAeroDerivation aero;
  };
  kcmloader = pkgs.callPackage ./kcmloader.nix {
    inherit mkAeroDerivation aero;
  };
  login-sessions = pkgs.callPackage ./login-sessions.nix {
    inherit mkAeroDerivation aero plasmashell;
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
