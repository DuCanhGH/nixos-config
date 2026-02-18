# https://github.com/nyakase/aerothemeplasma-nix/blob/b922785202501754c4503232aa5f172aeaef8b00/pkgs/system/plymouthvista.nix
{
  pkgs,
  lib,
  stdenvNoCC,
  makeFontsConf,
  aerofonts,
}:
stdenvNoCC.mkDerivation {
  name = "plymouth-vista";
  src = pkgs.fetchFromGitHub {
    owner = "rustussy";
    repo = "plymouth-vista";
    rev = "df5df7dfaab9dd3c1a8b2c57e0b91ff84660bf44";
    hash = "sha256-yoqWayJwc/IYq9m5N/sK/fThoRuOy1JSjIb4F09IVos=";
  };
  nativeBuildInputs = [ pkgs.imagemagick ];
  env = {
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ aerofonts ];
    };
  };
  postPatch = ''
    patchShebangs ./compile.sh ./pv_conf.sh ./gen_blur.sh
  '';
  buildPhase = ''
    runHook preBuild

    ./compile.sh
    XDG_CACHE_HOME="$(mktemp -d)" ./gen_blur.sh

    ./pv_conf.sh -s UseLegacyBootScreen -v 0
    ./pv_conf.sh -s UseShadow -v 1
    ./pv_conf.sh -s Pref -v 3
    ./pv_conf.sh -s AuthuiStyle -v 7
    ./pv_conf.sh -s PasswordTitle -v "Linux Boot Manager"
    ./pv_conf.sh -s AnswerTitle -v "Linux Boot Manager"
    ./pv_conf.sh -s StartingText -v "Starting Linux"
    ./pv_conf.sh -s ResumingText -v "Resuming Linux"
    ./pv_conf.sh -s NoGuiResumeText -v "Resuming Linux..."
    ./pv_conf.sh -s CopyrightText -v "© Microslop Copyschlop"

    substituteInPlace plymouth-vista.plymouth --replace-fail "/usr/share" "$out/share"
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/plymouth-vista
    cp -r images/ $out/share/plymouth/themes/plymouth-vista
    cp plymouth-vista.script plymouth-vista.plymouth $out/share/plymouth/themes/plymouth-vista
    runHook postInstall
  '';
  meta = {
    description = "Plymouth Vista";
    platforms = lib.platforms.linux;
  };
}
