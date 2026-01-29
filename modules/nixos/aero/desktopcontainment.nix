{ pkgs, lib, mkAeroDerivation, repo, commonCmakeFlags }:

mkAeroDerivation {
  pname = "desktopcontainment";
  version = "git";
  src = "${repo}/plasma/plasmoids/src/desktopcontainment";
  buildInputs = with pkgs; [
    kdePackages.knotifyconfig
    kdePackages.krunner
    kdePackages.ksvg
    kdePackages.plasma-activities
    kdePackages.plasma-activities-stats
  ];
  postPatch = ''
    sed -i 's/ecm_find_qmlmodule(org.kde.kirigami REQUIRED)/ecm_find_qmlmodule(org.kde.kirigami)/' CMakeLists.txt
  '';
  configurePhase = ''
    mkdir -p $TMPDIR/cmake-modules
    cat > $TMPDIR/cmake-modules/Findorg.kde.kirigami-QMLModule.cmake <<EOF
      set(org.kde.kirigami-QMLModule_FOUND TRUE)
      set(org.kde.kirigami-QMLModule_DIR "${pkgs.kdePackages.kirigami}/lib/qt-6/qml/org/kde/kirigami")
      message(STATUS "Found org.kde.kirigami-QMLModule")
    EOF
    export CMAKE_MODULE_PATH=$TMPDIR/cmake-modules:$CMAKE_MODULE_PATH
    cmake -B build -G Ninja ${lib.concatStringsSep " " commonCmakeFlags}
  '';
}