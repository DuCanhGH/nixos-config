{
  pkgs,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  name = "aerothemeplasma";
  src = pkgs.aero-repo;
  dontBuild = true;
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
      $out/share/color-schemes \
      $out/share/Kvantum \
      $out/share/sddm/themes \
      $out/share/sounds \
      $out/share/icons \
      $dev/plasma/plasmoids
    cp -r plasma/plasmoids/!(src) $out/share/plasma/plasmoids/
    cp -r plasma/desktoptheme $out/share/plasma/
    cp -r plasma/look-and-feel $out/share/plasma/
    cp -r plasma/layout-templates $out/share/plasma/
    cp -r plasma/shells $out/share/plasma/
    cp -r plasma/color_scheme/* $out/share/color-schemes
    cp -r misc/kvantum/Windows7Aero $out/share/Kvantum
    echo -e "[General]\ntheme=Windows7Aero" > $out/share/Kvantum/kvantum.kvconfig
    cp -r plasma/sddm/sddm-theme-mod $out/share/sddm/themes/
    cp -r "${pkgs.aero-icons-repo}/aero-drop" $out/share/icons/
    cp -r "${pkgs.aero-icons-repo}/Windows 7 Aero" $out/share/icons/
    cp -r "${pkgs.aero-sounds-repo}/Windows 7"* $out/share/sounds/
    ln -sf $out/share/icons/aero-drop $out/share/icons/default
    cp -r plasma/plasmoids/src/* $dev/plasma/plasmoids
    cp -r plasma/sddm $dev/plasma
    runHook postInstall
  '';
  meta = {
    description = "Aero for Plasma";
    platforms = lib.platforms.linux;
  };
}
