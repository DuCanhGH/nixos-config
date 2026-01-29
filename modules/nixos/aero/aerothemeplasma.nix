{ pkgs, lib, stdenv, repo }:

stdenv.mkDerivation {
  name = "aerothemeplasma";
  src = repo;
  nativeBuildInputs = [pkgs.gnutar];
  installPhase = ''
    mkdir -p $out/share/plasma \
      $out/share/kwin \
      $out/share/color-schemes \
      $out/share/Kvantum \
      $out/share/sddm/themes \
      $out/share/mime/packages \
      $out/share/sounds \
      $out/share/icons/aero
    cp -r "$src/plasma/desktoptheme" $out/share/plasma/
    cp -r "$src/plasma/look-and-feel" $out/share/plasma/
    cp -r "$src/plasma/plasmoids" $out/share/plasma/
    cp -r "$src/plasma/layout-templates" $out/share/plasma/
    cp -r "$src/plasma/shells" $out/share/plasma/
    cp -r "$src/kwin/effects" $out/share/kwin/
    cp -r "$src/kwin/tabbox" $out/share/kwin/
    cp -r "$src/kwin/outline" $out/share/kwin/
    cp -r "$src/kwin/scripts" $out/share/kwin/
    cp -r "$src/plasma/color_scheme" $out/share/
    cp -r "$src/misc/kvantum/Kvantum" $out/share/
    cp -r "$src/plasma/sddm/sddm-theme-mod" $out/share/sddm/themes/
    cp -r "$src/misc/mimetype"/* $out/share/mime/packages/
    tar -xzf "$src/misc/cursors/aero-drop.tar.gz" -C $out/share/icons
    tar -xzf "$src/misc/sounds/sounds.tar.gz" -C $out/share/sounds
  '';
  meta = {
    description = "Aero for Plasma";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
