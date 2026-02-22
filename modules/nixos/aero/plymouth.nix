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
    rev = "7c6d86524f53821f2b531ed4bc0444e0a3184d80";
    hash = "sha256-5HV3OS0PKcgh2HjKVkazkWdrubjm/rMSSQWaE/twPe0=";
  };
  nativeBuildInputs = [ pkgs.imagemagick ];
  env = {
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ aerofonts ];
    };
  };
  postPatch = "patchShebangs ./compile.sh ./pv_conf.sh ./gen_blur.sh";
  buildPhase = ''
    runHook preBuild

    ./compile.sh

    ./pv_conf.sh -s UseLegacyBootScreen -v 0
    ./pv_conf.sh -s UseShadow -v 1
    ./pv_conf.sh -s Pref -v 3
    ./pv_conf.sh -s AuthuiStyle -v 7
    ./pv_conf.sh -s PasswordTitle -v "Linux Boot Manager"
    ./pv_conf.sh -s AnswerTitle -v "Linux Boot Manager"
    ./pv_conf.sh -s UpdateTextMTL -v "Configuring Linux updates\n%i% complete\nDo not turn off your computer."
    ./pv_conf.sh -s StartingText -v "Starting Linux"
    ./pv_conf.sh -s ResumingText -v "Resuming Linux"
    ./pv_conf.sh -s NoGuiResumeText -v "Resuming Linux..."
    ./pv_conf.sh -s CopyrightText -v "© Microslop Copyschlop"

    XDG_CACHE_HOME="$(mktemp -d)" ./gen_blur.sh

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
