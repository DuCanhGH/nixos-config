# https://github.com/nyakase/aerothemeplasma-nix/blob/b922785202501754c4503232aa5f172aeaef8b00/pkgs/system/plymouthvista.nix
{
  pkgs,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "plymouth-vista";
  src = pkgs.fetchFromGitHub {
    owner = "rustussy";
    repo = "plymouth-vista";
    rev = "7022b4f4ccf8819969848e105ff0884d6e9482cd";
    hash = "sha256-rz0jPlxt137JbVmQRqDvUM5DaY3R8Fdpf3i+fJCOygU=";
  };
  postPatch = "patchShebangs ./compile.sh ./pv_conf.sh";
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
