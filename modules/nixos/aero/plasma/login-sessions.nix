{
  pkgs,
  mkAeroDerivation,
  aero,
  plasmashell,
  waylandEnabled,
}:

mkAeroDerivation {
  pname = "aero-login-sessions";
  src = "${aero.dev}/plasma/sddm/login-sessions";
  postFixup =
    if waylandEnabled then
      ''
        substituteInPlace $out/bin/startatp-wayland \
          --replace-fail "$out/libexec/plasma-dbus-run-session-if-needed" "${plasmashell}/libexec/plasma-dbus-run-session-if-needed" \
          --replace-fail "$out/bin/startplasma-wayland" "${plasmashell}/bin/startplasma-wayland"
      ''
    else
      ''substituteInPlace $out/bin/startatp --replace-fail "startplasma-x11" "${plasmashell}/bin/startplasma-x11"'';
  passthru.providedSessions = [
    (if waylandEnabled then "aerothemeplasma" else "aerothemeplasmax11")
  ];
}
