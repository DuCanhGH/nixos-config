{
  pkgs,
  mkAeroDerivation,
  aero,
  libplasma,
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
    sed -i '/export PLASMA_DEFAULT_SHELL/iexport LD_PRELOAD="${libplasma.out}/lib/libATPlasmaQuick.so ${libplasma.out}/lib/qt-6/qml/io/gitgud/wackyideas/plasma/core/libcorebindingsplugin.so''${LD_PRELOAD:+ }''${LD_PRELOAD}"' $out/bin/startatp-wayland
    sed -i '/export PLASMA_DEFAULT_SHELL/iexport LD_PRELOAD="${libplasma.out}/lib/libATPlasmaQuick.so ${libplasma.out}/lib/qt-6/qml/io/gitgud/wackyideas/plasma/core/libcorebindingsplugin.so''${LD_PRELOAD:+ }''${LD_PRELOAD}"' $out/bin/startatp

    substituteInPlace $out/bin/startatp-wayland \
      --replace-fail "$out/lib64/libexec/plasma-dbus-run-session-if-needed" "${pkgs.kdePackages.plasma-workspace}/libexec/plasma-dbus-run-session-if-needed" \
      --replace-fail "$out/bin/startplasma-wayland" "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland"
  '';
  passthru.providedSessions = [
    "aerothemeplasma"
    "aerothemeplasma-wayland"
  ];
}
