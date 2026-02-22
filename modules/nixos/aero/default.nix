{
  waylandEnabled ? false,
  pkgs,
  lib,
  stdenv,
  ...
}:
let
  libplasma = pkgs.callPackage ./kde/libplasma.nix { };
  plasmashell = pkgs.callPackage ./kde/plasmashell.nix {
    inherit libplasma;
  };
  commonCmakeFlags = ([
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_KF6=ON"
    "-DPlasma_DIR=${libplasma.dev}/lib/cmake/Plasma"
    "-DPlasmaQuick_DIR=${libplasma.dev}/lib/cmake/PlasmaQuick"
    "-DKPLUGINFACTORY_INCLUDE=${pkgs.kdePackages.kcoreaddons.dev}/include/KF6/KCoreAddons"
  ])
  ++ (lib.optionals waylandEnabled [
    "-DKWIN_BUILD_WAYLAND=ON"
  ]);
  aeroEffects = "${pkgs.aero-kwin-repo}/effects_cpp/${if waylandEnabled then "wayland" else "x11"}";
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
          pkg-config
          libplasma.dev
          kdePackages.extra-cmake-modules
          kdePackages.wrapQtAppsHook
          kdePackages.kcoreaddons.dev
        ];
        defaultBuild = (
          with pkgs;
          (
            [
              kdePackages.qtbase
              kdePackages.qttools
            ]
            ++ (if waylandEnabled then [ kdePackages.kwin ] else [ kdePackages.kwin-x11 ])
          )
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
  aero = pkgs.callPackage ./misc/aerothemeplasma.nix { };
  smod = pkgs.callPackage ./kde/smod.nix {
    inherit mkAeroDerivation aero;
  };
in
{
  inherit smod libplasma plasmashell;
  aerothemeplasma = aero;
  aeroglassblur = pkgs.callPackage ./effects/aeroglassblur.nix {
    inherit mkAeroDerivation aeroEffects smod;
  };
  aeroglide = pkgs.callPackage ./effects/aeroglide.nix {
    inherit mkAeroDerivation aeroEffects smod;
  };
  smodglow = pkgs.callPackage ./effects/smodglow.nix {
    inherit mkAeroDerivation smod;
  };
  smodsnap = pkgs.callPackage ./effects/smodsnap.nix {
    inherit mkAeroDerivation aeroEffects smod;
  };
  startupfeedback = pkgs.callPackage ./effects/startupfeedback.nix {
    inherit mkAeroDerivation aeroEffects smod;
  };
  kwin = pkgs.callPackage ./kde/kwin.nix {
    inherit mkAeroDerivation;
  };
  libshowdesktop = pkgs.callPackage ./kde/libshowdesktop.nix {
    inherit mkAeroDerivation;
  };
  libtaskmanager = pkgs.callPackage ./kde/libtaskmanager.nix {
    inherit mkAeroDerivation;
  };
  uac-polkit-agent = pkgs.callPackage ./kde/uac-polkit-agent.nix {
    inherit mkAeroDerivation;
  };
  aerofonts = pkgs.callPackage ./misc/aerofonts.nix { };
  kcmloader = pkgs.callPackage ./misc/kcmloader.nix {
    inherit mkAeroDerivation aero;
  };
  desktopcontainment = pkgs.callPackage ./plasma/desktopcontainment.nix {
    inherit mkAeroDerivation aero;
  };
  login-sessions = pkgs.callPackage ./plasma/login-sessions.nix {
    inherit mkAeroDerivation aero plasmashell;
  };
  notifications = pkgs.callPackage ./plasma/notifications.nix {
    inherit mkAeroDerivation aero;
  };
  sevenstart = pkgs.callPackage ./plasma/sevenstart.nix {
    inherit mkAeroDerivation aero;
  };
  seventasks = pkgs.callPackage ./plasma/seventasks.nix {
    inherit mkAeroDerivation aero;
  };
  systemtray = pkgs.callPackage ./plasma/systemtray.nix {
    inherit mkAeroDerivation aero;
  };
}
