{ lib, pkgs, qtbase, qtdeclarative, qttools, wrapQtAppsHook, ... }:

let
  stdenv = pkgs.stdenv;
  src = pkgs.fetchFromGitHub {
    owner = "WackyIdeas";
    repo = "aerothemeplasma";
    rev = "9c9d4f2a4e84319351428b8b13f84eb0eb4e2ada";
    hash = "sha256-fXxNDNm5dFRr5g3k0alEsoc83wyKMIt9Ud/yFOCT3II=";
  };
  plasmaVersion = lib.strings.removePrefix "libplasma-" pkgs.kdePackages.libplasma.meta.name;
  libplasma = pkgs.fetchzip {
    url = "https://invent.kde.org/plasma/libplasma/-/archive/v${plasmaVersion}/libplasma-v${plasmaVersion}.tar.gz";
    sha256 = "sha256-IPAfgi+Vsm+gPA8DMXfTsnuPRlDVCSQWr88LcG9HEK8=";
  };
  nativeBuildInputs = with pkgs; [
    bash cmake ninja pkg-config killall
    kdePackages.extra-cmake-modules
    kdePackages.kdecoration
    kdePackages.qtvirtualkeyboard
    kdePackages.qtmultimedia
    kdePackages.qt5compat
    kdePackages.qtwayland
    kdePackages.plasma-wayland-protocols
    kdePackages.plasma5support
    kdePackages.qtstyleplugin-kvantum
    kdePackages.ksvg
    kdePackages.kwin
    wrapQtAppsHook
  ];
in
{
  libplasma = stdenv.mkDerivation rec {
    pname = "aero-libplasma";
    version = "git";

    inherit src;
    inherit nativeBuildInputs;

    buildInputs = with pkgs; [
      qtbase
      qtdeclarative
      pkgs.binutils
    ];

    configurePhase = ''
      runHook preConfigure
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      cd "$PWD/misc/libplasma" >/dev/null || continue
      PWDDIR=$(pwd)
      SRCDIR="${pkgs.kdePackages.libplasma.meta.name}"
      mkdir -p build
      cp -r src ./build/$SRCDIR/
      cp -r ${libplasma}/* ./build/$SRCDIR
      cd ./build/$SRCDIR/
      mkdir -p build
      cd build
      cmake -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_INSTALL_RPATH='\$ORIGIN/..' -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -G Ninja ..
      cmake --build . --target corebindingsplugin
      cmake --build . --target install
      DISTDIR="$out/dist"
      mkdir -p $DISTDIR
      cp ./bin/org/kde/plasma/core/libcorebindingsplugin.so $DISTDIR
      for filename in "$PWD/bin/libPlasma"*; do
      	echo "Copying $filename to $DISTDIR"
      	cp "$filename" "$DISTDIR"
      done
      cd $PWDDIR
      cp apply $DISTDIR
      chmod +x "$DISTDIR/apply"
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      runHook postInstall
    '';
  };

  kwin = stdenv.mkDerivation rec {
    pname = "aero-kwin";
    version = "git";
    
    inherit src;
    inherit nativeBuildInputs;

    buildInputs = with pkgs; [
      qtbase
      qtdeclarative
      qttools
      pkgs.binutils
    ];

    configurePhase = ''
      runHook preConfigure
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      compile_kwin_decoration() {
        echo "Compiling SMOD decorations..."
        pushd "$PWD/kwin/decoration" >/dev/null || continue
        BUILD_DST="build"
        rm -rf "$BUILD_DST"
        mkdir "$BUILD_DST"
        cd "$BUILD_DST"
        cmake -DCMAKE_PREFIX_PATH=$out -DCMAKE_INSTALL_PREFIX=$out .. -G Ninja
        ninja
        ninja install
        popd >/dev/null || continue
        echo "Done."
      }
      compile_kcm_loader() {
        echo "Compiling KCM loader..."
        pushd "$PWD/plasma/aerothemeplasma-kcmloader" >/dev/null || continue
        BUILD_DST="build"
        rm -rf "$BUILD_DST"
        mkdir "$BUILD_DST"
        cd "$BUILD_DST"
        cmake -DCMAKE_PREFIX_PATH=$out -DCMAKE_INSTALL_PREFIX=$out .. -G Ninja
        ninja
        ninja install
        popd >/dev/null || continue
        echo "Done."
      }
      compile_kwin_effect() {
        BUILD_DST="build-wl"
        BUILD_PLATFORM="Wayland"
        BUILD_PARAM="-DKWIN_BUILD_WAYLAND=ON"
        rm -rf "$BUILD_DST"
        mkdir "$BUILD_DST"
        cd "$BUILD_DST"
        echo "Building $BUILD_PLATFORM effect..."
        cmake -DCMAKE_PREFIX_PATH=$out -DCMAKE_INSTALL_PREFIX=$out .. $BUILD_PARAM -G Ninja
        ninja
        ninja install
      }
      compile_kwin_decoration
      compile_kcm_loader

      echo "Compiling KWin effects..."
      for filename in "$PWD/kwin/effects_cpp/"*; do
        pushd "$filename" >/dev/null || continue
        echo "Compiling $(pwd)"
        compile_kwin_effect
        echo "Done."
        popd >/dev/null || continue
      done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # Copy static resources into the package output so Plasma can discover
      # them from the system profile. Do not call user-session tools here.
      mkdir -p $out/share/kwin
      # copy SMOD resources, outline, effects JS, scripts, tabbox
      # Installs the SMOD folder which contains resources used by other ATP components.
      echo -e "Copying SMOD resources..."
      mkdir -p $out/share
      cp -r "$PWD/kwin/smod" "$out/share/"
      echo "Done."

      echo "Copying outline..."
      KWIN_DIR="$out/share/kwin"
      cp -r "$PWD/kwin/outline" "$KWIN_DIR"
      echo "Done."

      echo -e "Copying KWin effects (JS)..."
      mkdir -p "$out/share/kwin/effects"
      cp -r "$PWD/kwin/effects/"* "$out/share/kwin/effects/" || true
      echo "Done."
      
      echo -e "Copying KWin scripts..."
      mkdir -p "$out/share/kwin/scripts"
      cp -r "$PWD/kwin/scripts/"* "$out/share/kwin/scripts/" || true
      echo "Done."

      echo "Copying KWin task switchers..."
      mkdir -p "$out/share/kwin/tabbox"
      cp -r "$PWD/kwin/tabbox/"* "$out/share/kwin/tabbox/" || true
      echo "Done."

      # Use symlinks so the KWin components are visible under both Wayland and X11.
      LOCAL_DIR="$out/share"
      cd "$LOCAL_DIR"
      echo "Making kwin-x11 and kwin-wayland symlinks..."
      ln -s kwin kwin-x11
      ln -s kwin kwin-wayland
      echo "Done."

      # Create a helper script users can run (or the systemd user service can
      # call) to register these components into the running Plasma session
      # (this requires a logged-in user and kpackagetool6 available).
      mkdir -p $out/bin
      cat > $out/bin/aero-register <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

export LANG=C.UTF-8
export LC_ALL=C.UTF-8

SCRIPT_DIR=$(cd "$(dirname "''${BASH_SOURCE[0]}")/.." && pwd)
KWIN_SHARE="$SCRIPT_DIR/share/kwin"

register_dir() {
  local dir="$1" type="$2"
  [ -d "$dir" ] || return 0
  for p in "$dir"/*; do
    [ -d "$p" ] || continue
    echo "Registering $p as $type"
    COMPONENT=$(basename "$p")
    INSTALLED=$(kpackagetool6 -l -t "$type" | grep -F "$COMPONENT" || true)
    if [[ -z "$INSTALLED" ]]; then
      echo "$COMPONENT isn't installed, installing normally..."
      kpackagetool6 -t "$type" -i "$p" || echo "Failed to install $COMPONENT"
    else
      echo "$COMPONENT found, upgrading..."
      kpackagetool6 -t "$type" -u "$p" || echo "Failed to install $COMPONENT"
    fi
    echo -e "\n"
  done
}

register_dir "$KWIN_SHARE/effects" "KWin/Effect"
register_dir "$KWIN_SHARE/scripts" "KWin/Script"
register_dir "$KWIN_SHARE/tabbox" "KWin/WindowSwitcher"

echo "Finished registering Aero KWin components."
EOF
      chmod +x $out/bin/aero-register

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Aero KWin components";
      platforms = platforms.linux;
    };
  };

  # Does not work.
  plasmoids = stdenv.mkDerivation rec {
    pname = "aero-plasmoids";
    version = "git";
    
    inherit src;
    inherit nativeBuildInputs;

    buildInputs = with pkgs; [
      qtbase qtdeclarative
      kdePackages.plasma5support
      kdePackages.plasma-activities
      kdePackages.plasma-activities-stats
      kdePackages.ksvg
      kdePackages.knotifyconfig
      kdePackages.krunner
      pkgs.binutils
    ];

    configurePhase = ''
      runHook preConfigure
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      CUR_DIR=$(pwd)

      compile_plasmoid() {
        BUILD_DST="build"
        rm -rf "$BUILD_DST"
        mkdir "$BUILD_DST"
        cd "$BUILD_DST"
        cmake -DCMAKE_INSTALL_PREFIX=$out .. -G Ninja
        ninja
        ninja install
      }

      echo "Compiling plasmoids..."

      for filename in "$PWD/plasma/plasmoids/src/"*; do
        cd "$filename"
        echo "Compiling $(pwd)"
        compile_plasmoid
        echo "Done."
        cd "$CUR_DIR"
      done

      # Installs or upgrades plasmoids using kpackagetool6
      install_plasmoid() {
        PLASMOID=$(basename "$1")
        if [[ $PLASMOID == 'src' ]]; then
          echo "Skipping $PLASMOID"
          return
        fi
        INSTALLED=$(kpackagetool6 -l -t "Plasma/Applet" | grep $PLASMOID)
        if [[ -z "$INSTALLED" ]]; then
          echo "$PLASMOID isn't installed, installing normally..."
          kpackagetool6 -t "Plasma/Applet" -i "$1"
        else
          echo "$PLASMOID found, upgrading..."
          kpackagetool6 -t "Plasma/Applet" -u "$1"
        fi
        echo -e "\n"
        cd "$CUR_DIR"
      }

      # KPackageTool will update plasmoids on the fly, and this results in
      # the system tray forgetting the visibility status of upgraded plasmoids.
      # As such, we need to first terminate plasmashell in order to retain
      # saved configurations

      killall plasmashell || echo "plasmashell not running, continuing..."

      for filename in "$PWD/plasma/plasmoids/"*; do
        install_plasmoid "$filename"
      done

      setsid plasmashell --replace & # Restart plasmashell and detach it from the script
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Aero plasmoids";
      platforms = platforms.linux;
    };
  };

# cmake -DCMAKE_INSTALL_PREFIX=$out -G Ninja ..
# cmake --build . --target corebindingsplugin
#   # plasmoids: compile plasmoids (C++ where present) and stage
#   plasmoids = stdenv.mkDerivation rec {
#     pname = "aero-plasmoids";
#     version = "git";

#     inherit src;

#     nativeBuildInputs = with pkgs; [
#       bash cmake ninja pkg-config
#       kdePackages.extra-cmake-modules
#     ];

#     buildInputs = with pkgs; [
#       qt6.qtbase
#       kdePackages.kcoreaddons
#       kdePackages.plasma-framework
#       pkgs.binutils
#     ];

#     postPatch = ''
#       cat > build-plasmoids.sh <<'EOF'
# #!/usr/bin/env bash
# set -euo pipefail
# OUT_SHARE="${OUT_SHARE:-./share}"
# mkdir -p "$OUT_SHARE/plasmoids"

# # iterate plasmoids; if a plasmoid has src/ or an install.sh, run it in build output and then copy
# PLASMOIDS_DIR="$PWD/plasma/plasmoids"
# for p in "$PLASMOIDS_DIR"/*; do
#   if [ -d "$p" ]; then
#     name=$(basename "$p")
#     echo "Processing plasmoid $name"
#     # if plasmoid has src or an install.sh, attempt to build it
#     if [ -d "$p/src" ] || [ -f "$p/install.sh" ]; then
#       pushd "$p" >/dev/null
#       if [ -f install.sh ]; then
#         bash install.sh --ninja || true
#       else
#         mkdir -p build && cd build
#         cmake -DCMAKE_INSTALL_PREFIX=/usr -G Ninja ..
#         cmake --build . || true
#         cd ..
#       fi
#       popd >/dev/null
#     fi
#     # copy plasmoid folder
#     mkdir -p "$OUT_SHARE/plasmoids"
#     rm -rf "$OUT_SHARE/plasmoids/$name"
#     cp -a "$p" "$OUT_SHARE/plasmoids/$name"
#   fi
# done
# EOF
#       chmod +x build-plasmoids.sh
#     '';

#     buildPhase = ''
#       runHook preBuild
#       export OUT_SHARE="$out/share"
#       mkdir -p "$OUT_SHARE"
#       export PATH="${pkgs.cmake}/bin:${pkgs.ninja}/bin:${stdenv.cc}/bin:${pkgs.curl}/bin:/run/current-system/sw/bin"
#       ./build-plasmoids.sh
#       runHook postBuild
#     '';

#     installPhase = ''
#       runHook preInstall
#       mkdir -p $out/share/plasmoids
#       cat > $out/README-plasmoids <<EOF
# Plasmoids staged under $out/share/plasmoids
# EOF
#       runHook postInstall
#     '';

#     meta = with pkgs.lib; {
#       description = "AeroThemePlasma plasmoids (staged)";
#       platforms = platforms.linux;
#     };
#   };

#   ####################################################################
#   # 4) assets: stage static assets (desktop theme, kvantum, icons, sounds, sddm, color-schemes)
#   ####################################################################
#   assets = stdenv.mkDerivation rec {
#     pname = "aero-assets";
#     version = "git";

#     inherit src;

#     nativeBuildInputs = with pkgs; [ bash tar unzip curl ];

#     buildPhase = ''
#       runHook preBuild
#       OUT_SHARE="$out/share"
#       mkdir -p "$OUT_SHARE"

#       # copy desktop theme(s)
#       if [ -d "$PWD/plasma/desktoptheme" ]; then
#         cp -a "$PWD/plasma/desktoptheme" "$OUT_SHARE/"
#       fi

#       # color schemes
#       mkdir -p "$OUT_SHARE/color-schemes"
#       if [ -f "$PWD/plasma/color_scheme/Aero.colors" ]; then
#         cp -a "$PWD/plasma/color_scheme/Aero.colors" "$OUT_SHARE/color-schemes/"
#       fi

#       # aurorae decorations
#       if [ -d "$PWD/plasma/aurorae" ]; then
#         cp -a "$PWD/plasma/aurorae" "$OUT_SHARE/aurorae/"
#       fi

#       # plasmoids (copy sources)
#       if [ -d "$PWD/plasma/plasmoids" ]; then
#         cp -a "$PWD/plasma/plasmoids" "$OUT_SHARE/plasmoids" || true
#       fi

#       # kvantum
#       if [ -d "$PWD/kvantum" ]; then
#         cp -a "$PWD/kvantum" "$OUT_SHARE/kvantum" || true
#       fi

#       # kwin assets (smod, scripts, effects JS, tabbox)
#       if [ -d "$PWD/kwin" ]; then
#         cp -a "$PWD/kwin" "$OUT_SHARE/kwin" || true
#       fi

#       # sddm theme & login sessions
#       if [ -d "$PWD/plasma/sddm" ]; then
#         cp -a "$PWD/plasma/sddm" "$OUT_SHARE/sddm" || true
#       fi

#       # misc: icons, cursors, sounds, fontconfig
#       if [ -d "$PWD/misc/icons" ]; then
#         mkdir -p "$OUT_SHARE/icons"
#         cp -a "$PWD/misc/icons/"* "$OUT_SHARE/icons/" || true
#       fi
#       if [ -d "$PWD/misc/cursors" ]; then
#         mkdir -p "$OUT_SHARE/icons"
#         cp -a "$PWD/misc/cursors/"* "$OUT_SHARE/icons/" || true
#       fi
#       if [ -d "$PWD/misc/sounds" ]; then
#         mkdir -p "$OUT_SHARE/sounds"
#         cp -a "$PWD/misc/sounds/"* "$OUT_SHARE/sounds/" || true
#       fi
#       if [ -d "$PWD/misc/fontconfig" ]; then
#         mkdir -p "$OUT_SHARE/fontconfig"
#         cp -a "$PWD/misc/fontconfig/"* "$OUT_SHARE/fontconfig/" || true
#       fi

#       runHook postBuild
#     '';

#     installPhase = ''
#       runHook preInstall
#       mkdir -p $out/share
#       cat > $out/README-assets <<EOF
# AeroThemePlasma static assets staged under:
#   $out/share
# EOF
#       runHook postInstall
#     '';

#     meta = with pkgs.lib; {
#       description = "Aero static assets (plasmoids, themes, icons, kvantum, sddm)";
#       platforms = platforms.linux;
#     };
#   };
}
