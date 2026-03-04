{
  pkgs,
  mkAeroDerivation,
}:
mkAeroDerivation {
  pname = "aero-uac-polkit-agent";
  src = pkgs.repos.uac-polkit-agent;
  postFixup = ''
    rm -rf $out/share/systemd/user/uac-polkit-agent.service
    substituteInPlace $out/etc/systemd/user/plasma-polkit-agent.service.d/uac-polkit-agent.conf \
      --replace-fail "/bin/sh" "${pkgs.bash}/bin/bash" \
      --replace-fail "$out/libexec/polkit-kde-authentication-agent-1" "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
  '';
}
