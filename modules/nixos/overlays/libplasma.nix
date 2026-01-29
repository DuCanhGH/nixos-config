final: prev: {
  kdePackages = prev.kdePackages // {
    libplasma = prev.kdePackages.libplasma.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        rm src/declarativeimports/core/private/DefaultToolTip.qml
        rm src/declarativeimports/core/tooltiparea.cpp
        rm src/declarativeimports/core/tooltiparea.h
        rm src/declarativeimports/core/tooltipdialog.cpp
        rm src/plasmaquick/plasmawindow.cpp
        rm src/plasmaquick/popupplasmawindow.cpp
        cp -r ${prev.aero.repo}/misc/libplasma/src .
      '';
    });
  };
}