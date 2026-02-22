# https://github.com/nyakase/aerothemeplasma-nix/blob/8b3aa15df981b4620bf695fad1f2b4df055ea3a6/flake.nix
{ pkgs }:
pkgs.kdePackages.libplasma.overrideAttrs (oldAttrs: {
  pname = "aero-libplasma";
  # https://github.com/NixOS/nixpkgs/blob/76e87812ad15014a37ea69953bbb33091c515690/pkgs/kde/plasma/libplasma/rb-extracomponents.patch
  postPatch = ''
    shopt -s globstar
    rm -rf ./* && cp -r ${pkgs.aero-libplasma-repo}/* .
    substituteInPlace src/declarativeimports/plasmaextracomponents/CMakeLists.txt \
      --replace-fail "ecm_finalize_qml_module" "add_dependencies(plasmaextracomponentsplugin org_kde_plasmacomponents3)
        ecm_finalize_qml_module"
    substituteInPlace src/**/CMakeLists.txt \
      --replace-quiet 'URI "org.kde.plasma.' 'URI "io.gitgud.wackyideas.plasma.' \
      --replace-quiet "EXPORT_NAME Plasma" "OUTPUT_NAME ATPlasma"
    substituteInPlace src/**/*.qml --replace-quiet "import org.kde.plasma." "import io.gitgud.wackyideas.plasma."
    substituteInPlace src/declarativeimports/CMakeLists.txt --replace-fail "add_subdirectory(kirigamiplasmastyle)" ""
    substituteInPlace src/plasma/CMakeLists.txt --replace-fail "add_subdirectory(packagestructure)" ""
    substituteInPlace src/**/*.cpp --replace-quiet "org.kde.plasma.core" "io.gitgud.wackyideas.plasma.core"
  '';
  ninjaFlags = [ "corebindingsplugin" ];
  postFixup = "rm -rf $out/share";
})
