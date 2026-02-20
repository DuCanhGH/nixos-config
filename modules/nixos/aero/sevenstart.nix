{
  pkgs,
  mkAeroDerivation,
  aero,
}:

mkAeroDerivation {
  pname = "aero-sevenstart";
  src = "${aero.dev}/plasma/plasmoids/sevenstart_src";
  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace-fail "add_subdirectory(src)" "find_package(PlasmaQuick)
      add_subdirectory(src)"
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "Plasma" "Plasma::Plasma" \
      --replace-fail "/usr/include/Plasma" "Plasma"
  '';
}
