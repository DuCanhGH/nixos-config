{ pkgs, lib }:
let
  plymouth-vista-repo = pkgs.fetchFromGitHub {
    owner = "rustussy";
    repo = "plymouth-vista";
    rev = "46e13ba4c6eda056df01a9b54f23368eb97b2ef5";
    hash = "sha256-bVbtuHk45b3T94CzReuaEP5yrzv4Np2iCaZkgmmc1Eo=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "plymouth-vista";
  src = plymouth-vista-repo;
  prePatch = ''
    substituteInPlace PlymouthVista.plymouth \
      --replace "/usr/share/plymouth/themes/PlymouthVista" "$out/share/plymouth/themes/plymouth-vista" \
      --replace "PlymouthVista.script" "plymouth-vista.script"
  '';
  buildPhase = ''
    pushd ./src
    cat bootlegacy.sp boot7.sp bootmgr.sp plymouth_config.sp stringutils.sp wupdate.sp shutdown.sp vistaresume.sp main.sp > ../plymouth-vista.script
    popd
    substituteInPlace plymouth-vista.script \
      --replace-fail "global.UseLegacyBootScreen = 1" "global.UseLegacyBootScreen = 0" \
      --replace-fail "global.UseShadow = 0" "global.UseShadow = 1" \
      --replace-fail "global.Pref = 1" "global.Pref = 2" \
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
