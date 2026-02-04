final: prev: {
  kdePackages = prev.kdePackages // {
    polkit-kde-agent-1 = prev.kdePackages.polkit-kde-agent-1.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        cp -r ${prev.aero-repo}/misc/uac-polkitagent/patches/* .
      '';
    });
  };
  aero = final.callPackage ../aero {};
}