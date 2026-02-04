{ mkAeroDerivation, repo }:

mkAeroDerivation {
  pname = "aero-login-sessions";
  src = "${repo}/plasma/sddm/login-sessions";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/xsessions
    cp build/startatp $out/bin
    cp build/aerothemeplasmax11.desktop $out/share/xsessions/aerothemeplasma.desktop
  '';
  passthru.providedSessions = [ "aerothemeplasma" ];
}