{
  pkgs,
  mkAeroDerivation,
  aero,
  plasmashell
}:

mkAeroDerivation {
  pname = "aero-login-sessions";
  src = "${aero.dev}/plasma/sddm/login-sessions";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/xsessions
    mkdir -p $out/share/wayland-sessions
    cp build/startatp $out/bin
    cp build/startatp-wayland $out/bin
    cp build/aerothemeplasmax11.desktop $out/share/xsessions/aerothemeplasma.desktop
    cp build/aerothemeplasma.desktop $out/share/wayland-sessions/aerothemeplasma-wayland.desktop
  '';
  postFixup = ''
    substituteInPlace $out/bin/startatp \
      --replace-fail "startplasma-x11" "${plasmashell}/bin/startplasma-x11"

    substituteInPlace $out/bin/startatp-wayland \
      --replace-fail "$out/lib64/libexec/plasma-dbus-run-session-if-needed" "${plasmashell}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "$out/bin/startplasma-wayland" "${plasmashell}/bin/startplasma-wayland"
  '';
  passthru.providedSessions = [
    "aerothemeplasma"
    "aerothemeplasma-wayland"
  ];
}
