{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-kwin";
  src = pkgs.repos.aero-kwin;
  dontBuild = true;
  postPatch = ''
    substituteInPlace $(find . -type f -name '*.qml' -o -name '*.js') \
      --replace-quiet "import org.kde.plasma.core" "import io.gitgud.wackyideas.plasma.core" \
      --replace-quiet "import org.kde.plasma.plasmoid" "import io.gitgud.wackyideas.plasma.plasmoid"
  '';
}
