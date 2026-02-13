{
  pkgs,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  name = "aerofonts";
  src = ../fonts;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp *.ttf $out/share/fonts/truetype
  '';
  meta = {
    description = "Segoe UI fonts";
    platforms = lib.platforms.linux;
  };
}
