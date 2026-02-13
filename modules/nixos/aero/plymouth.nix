{ pkgs, lib }:
let
  plymouth-vista-repo = pkgs.fetchFromGitHub {
    owner = "rustussy";
    repo = "plymouth-vista";
    rev = "d9f0d8848db3394521b595298da0d7151ff7eb65";
    hash = "sha256-yZwjd/k72AsfAoMrmyZPL7WBYgc1ed+/xy1y10uVtB0=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "plymouth-vista";
  src = plymouth-vista-repo;
  prePatch = ''
    substituteInPlace PlymouthVista.plymouth \
      --replace-fail "/usr/share/plymouth/themes/PlymouthVista" "$out/share/plymouth/themes/plymouth-vista" \
      --replace-fail "PlymouthVista.script" "plymouth-vista.script"
  '';
  nativeBuildInputs = [ pkgs.imagemagick ];
  buildPhase = ''
    pushd ./src
    cat bootlegacy.sp boot7.sp bootmgr.sp plymouth_config.sp stringutils.sp wupdate.sp shutdown.sp vistaresume.sp main.sp > ../plymouth-vista.script
    popd
    config_keys=("ShutdownText" "UpdateTextMTL" "RebootText" "LogoffText")
    declare -A config_values
    config_values["''${config_keys[0]}"]="Shutting down..."
    config_values["''${config_keys[1]}"]="Configuring Windows Updates\n%i% complete\nDo not turn off your computer."
    config_values["''${config_keys[2]}"]="Rebooting..."
    config_values["''${config_keys[3]}"]="Logging off..."
    escape_sed() {
      local s="$1"
      s="''${s//\\/\\\\}"   # \ -> \\
      s="''${s//&/\\&}"     # & -> \&
      s="''${s//|/\\|}"     # | -> \|
      printf '%s' "$s"
    }
    for key in "''${!config_values[@]}"; do
      value=''${config_values[$key]}
      escaped="$(escape_sed "$value")"
      sed -E -i "s|^([[:space:]]*global\.''${key}[[:space:]]*=[[:space:]]*)\"[^\"]*\";|\1\"''${escaped}\";|" plymouth-vista.script
    done
    unformatted_text=''${config_values["UpdateTextMTL"]}
    for i in {0..100}; do
      key="Update$i"
      value=$(echo $unformatted_text | sed "s/"%i"/$i/g")
      config_values["$key"]="$value"
    done
    unset config_values["UpdateTextMTL"]
    export FONTCONFIG_FILE=${pkgs.fontconfig}/etc/fonts/fonts.conf
    export FONTCONFIG_PATH=${pkgs.fontconfig}/etc/fonts
    export FC_CACHEDIR="$PWD/.fontconfig-cache"
    export XDG_CACHE_HOME="$PWD/.cache"
    mkdir -p "$FC_CACHEDIR" "$XDG_CACHE_HOME"
    ${pkgs.fontconfig}/bin/fc-cache -v -f "$FC_CACHEDIR" || true
    FONT="${pkgs.aero.aerofonts}/share/fonts/truetype/segoeui.ttf"
    # size = actual_size + 1
    SHADOW_SIZE=19
    for key in "''${!config_values[@]}"; do
      value=''${config_values[$key]}

      dimensions=$(magick -density 96 -font "$FONT" -pointsize "$SHADOW_SIZE" label:"$value" -format "%[fx:w+1]x%[fx:h]" info:)

      magick -density 96 -size "$dimensions" xc:none \
        -font "$FONT" -pointsize "$SHADOW_SIZE" \
        -fill "rgba(0,0,0,0.8)" \
        -gravity center \
        -annotate +0-1 "$value" \
        -blur 0x2 \
        -channel A -evaluate multiply 0.8 +channel \
        -trim +repage "./images/blur$key.png"
    done
    substituteInPlace plymouth-vista.script \
      --replace-fail "global.UseLegacyBootScreen = 1" "global.UseLegacyBootScreen = 0" \
      --replace-fail "global.UseShadow = 0" "global.UseShadow = 1" \
      --replace-fail "global.Pref = 1" "global.Pref = 3" \
      --replace-fail 'global.AuthuiStyle = "vista"' 'global.AuthuiStyle = "7"' \
      --replace-fail 'global.PasswordTitle = "Windows Boot Manager"' 'global.PasswordTitle = "Linux Boot Manager"' \
      --replace-fail 'global.AnswerTitle = "Windows Boot Manager"' 'global.AnswerTitle = "Linux Boot Manager"' \
      --replace-fail 'global.StartingText = "Starting Windows"' 'global.StartingText = "Starting Linux"' \
      --replace-fail 'global.ResumingText = "Resuming Windows"' 'global.ResumingText = "Resuming Linux"' \
      --replace-fail 'global.NoGuiResumeText = "Resuming Windows..."' 'global.NoGuiResumeText = "Resuming Linux..."' \
      --replace-fail 'global.CopyrightText = "© Microsoft Corporation"' 'global.CopyrightText = "© Microslop Copyschlop"'
  '';
  installPhase = ''
    mkdir -p $out/share/plymouth/themes/plymouth-vista
    cp -r images/ $out/share/plymouth/themes/plymouth-vista
    cp plymouth-vista.script $out/share/plymouth/themes/plymouth-vista
    cp PlymouthVista.plymouth $out/share/plymouth/themes/plymouth-vista/plymouth-vista.plymouth
  '';
  meta = {
    description = "Plymouth Vista";
    platforms = lib.platforms.linux;
  };
}
