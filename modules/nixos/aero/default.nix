{
  waylandEnabled ? false,
  pkgs,
  lib,
  stdenv,
  ...
}:
let
  libplasma = pkgs.callPackage ./libplasma.nix { };
  plasmashell = pkgs.callPackage ./plasmashell.nix {
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
  aero = pkgs.callPackage ./aerothemeplasma.nix { };
  decoration = pkgs.callPackage ./decoration.nix {
    inherit mkAeroDerivation aero;
  };
in
{
  inherit decoration libplasma plasmashell;
  aerothemeplasma = aero;
  aerofonts = pkgs.callPackage ./aerofonts.nix { };
  aeroglassblur = pkgs.callPackage ./aeroglassblur.nix {
    inherit mkAeroDerivation aeroEffects decoration;
  };
  aeroglide = pkgs.callPackage ./aeroglide.nix {
    inherit mkAeroDerivation aeroEffects decoration;
  };
  desktopcontainment = pkgs.callPackage ./desktopcontainment.nix {
    inherit mkAeroDerivation aero;
  };
  kcmloader = pkgs.callPackage ./kcmloader.nix {
    inherit mkAeroDerivation aero;
  };
  kwin = pkgs.callPackage ./kwin.nix {
    inherit mkAeroDerivation;
  };
  libshowdesktop = pkgs.callPackage ./libshowdesktop.nix {
    inherit mkAeroDerivation;
  };
  libtaskmanager = pkgs.callPackage ./libtaskmanager.nix {
    inherit mkAeroDerivation;
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
    inherit mkAeroDerivation decoration;
  };
  smodsnap = pkgs.callPackage ./smodsnap.nix {
    inherit mkAeroDerivation aeroEffects decoration;
  };
  startupfeedback = pkgs.callPackage ./startupfeedback.nix {
    inherit mkAeroDerivation aeroEffects decoration;
  };
  systemtray = pkgs.callPackage ./systemtray.nix {
    inherit mkAeroDerivation aero;
  };
  uac-polkit-agent = pkgs.callPackage ./uac-polkit-agent.nix {
    inherit mkAeroDerivation;
  };
}
