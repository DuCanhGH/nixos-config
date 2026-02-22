{
  pkgs,
  mkAeroDerivation,
  aero,
  plasmashell
}:

mkAeroDerivation {
  pname = "aero-login-sessions";
  src = "${aero.dev}/plasma/sddm/login-sessions";
  postFixup = ''
    substituteInPlace $out/bin/startatp \
      --replace-fail "startplasma-x11" "${plasmashell}/bin/startplasma-x11"

    substituteInPlace $out/bin/startatp-wayland \
      --replace-fail "$out/libexec/plasma-dbus-run-session-if-needed" "${plasmashell}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "$out/bin/startplasma-wayland" "${plasmashell}/bin/startplasma-wayland"
  '';
  passthru.providedSessions = [
    "aerothemeplasma"
    "aerothemeplasmax11"
  ];
}
