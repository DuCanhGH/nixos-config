{
  pkgs,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  name = "aerofonts";
  src = ../fonts;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype/
    install -Dm644 *.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';
  meta = {
    description = "Segoe UI fonts";
    platforms = lib.platforms.linux;
  };
}
