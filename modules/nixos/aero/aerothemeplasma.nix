{
  pkgs,
  lib,
  stdenvNoCC,
  repo,
}:

stdenvNoCC.mkDerivation {
  name = "aerothemeplasma";
  src = repo;
  dontBuild = true;
  nativeBuildInputs = [ pkgs.gnutar ];
  outputs = [
    "out"
    "dev"
  ];
  postPatch = ''
    substituteInPlace $(find plasma -type f -name '*.qml' -o -name '*.js') \
      --replace-quiet "import org.kde.plasma.core" "import io.gitgud.wackyideas.plasma.core" \
      --replace-quiet "import org.kde.plasma.plasmoid" "import io.gitgud.wackyideas.plasma.plasmoid"
  '';
  installPhase = ''
    runHook preInstall
    shopt -s extglob
    mkdir -p $out/share/plasma/plasmoids \
      $out/share/kwin \
      $out/share/color-schemes \
      $out/share/Kvantum \
      $out/share/sddm/themes \
      $out/share/mime/packages \
      $out/share/sounds \
      $out/share/icons \
      $dev/kwin/effects \
      $dev/plasma/plasmoids
    cp -r plasma/plasmoids/!(src) $out/share/plasma/plasmoids/
    cp -r plasma/desktoptheme $out/share/plasma/
    cp -r plasma/look-and-feel $out/share/plasma/
    cp -r plasma/layout-templates $out/share/plasma/
    cp -r plasma/shells $out/share/plasma/
    cp -r plasma/color_scheme/* $out/share/color-schemes
    cp -r kwin/effects $out/share/kwin/
    cp -r kwin/tabbox $out/share/kwin/
    cp -r kwin/outline $out/share/kwin/
    cp -r kwin/scripts $out/share/kwin/
    ln -sf $out/share/kwin $out/share/kwin-x11
    ln -sf $out/share/kwin $out/share/kwin-wayland
    cp -r kwin/smod $out/share/
    cp -r misc/kvantum/Kvantum $out/share/
    cp -r plasma/sddm/sddm-theme-mod $out/share/sddm/themes/
    cp -r misc/mimetype/* $out/share/mime/packages/
    tar -xzf misc/cursors/aero-drop.tar.gz -C $out/share/icons
    ln -sf $out/share/icons/aero-drop $out/share/icons/default
    tar -xzf "misc/icons/Windows 7 Aero.tar.gz" -C "$out/share/icons/"
    tar -xzf misc/sounds/sounds.tar.gz -C $out/share/sounds
    cp -r kwin/effects_cpp/* $dev/kwin/effects
    cp -r kwin/decoration $dev/kwin/
    cp -r plasma/plasmoids/src/* $dev/plasma/plasmoids
    cp -r plasma/aerothemeplasma-kcmloader $dev/plasma
    cp -r plasma/sddm $dev/plasma
    runHook postInstall
  '';
  meta = {
    description = "Aero for Plasma";
    platforms = lib.platforms.linux;
  };
}
