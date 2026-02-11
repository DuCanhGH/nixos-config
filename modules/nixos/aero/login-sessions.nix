{
  pkgs,
  mkAeroDerivation,
  repo,
}:

mkAeroDerivation {
  pname = "aero-login-sessions";
  src = "${repo}/plasma/sddm/login-sessions";
  prePatch = ''
    cat startatp-wayland.cmake
    substituteInPlace startatp-wayland.cmake \
      --replace-fail "@CMAKE_INSTALL_FULL_LIBEXECDIR@" "${pkgs.kdePackages.plasma-workspace}/libexec"
    substituteInPlace startatp-wayland.cmake \
      --replace-fail "\''${CMAKE_INSTALL_FULL_BINDIR}/startplasma-wayland" "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland"
  '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/xsessions
    mkdir -p $out/share/wayland-sessions
    cp build/startatp $out/bin
    cp build/startatp-wayland $out/bin
    cp build/aerothemeplasmax11.desktop $out/share/xsessions/aerothemeplasma.desktop
    cp build/aerothemeplasma.desktop $out/share/wayland-sessions/aerothemeplasma-wayland.desktop
  '';
  passthru.providedSessions = [
    "aerothemeplasma"
    "aerothemeplasma-wayland"
  ];
}
