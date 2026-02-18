{ pkgs, libplasma }:
pkgs.kdePackages.plasma-workspace.overrideAttrs (oldAttrs: {
  pname = "aero-plasmashell";
  cmakeFlags = oldAttrs.cmakeFlags ++ [
    "-DPlasma_DIR=${libplasma.dev}/lib/cmake/Plasma"
    "-DPlasmaQuick_DIR=${libplasma.dev}/lib/cmake/PlasmaQuick"
  ];
  extraPropagatedBuildInputs = (oldAttrs.extraPropagatedBuildInputs or [ ]) ++ [
    libplasma
  ];
  excludeDependencies = [ "libplasma" ];
  ninjaFlags = [
    "plasmashell"
    "startplasma-x11"
    "startplasma-wayland"
    "klookandfeel"
    "kworkspace"
    "krdb"
    "ksplashqml"
  ];
  installPhase = ''
    runHook preInstall
    ninja shell/install startkde/install libklookandfeel/install libkworkspace/install kcms/krdb/install ksplash/install
    runHook postInstall
  '';
  passthru.providedSessions = [ ];
})
