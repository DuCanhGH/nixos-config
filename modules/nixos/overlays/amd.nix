final: prev: {
  xf86-video-amdgpu = prev.xf86-video-amdgpu.overrideAttrs (old: {
    patches = [
      # to fix https://github.com/NixOS/nixpkgs/issues/483585 aka https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/issues/8
      # apply patches from https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/merge_requests/76
      (prev.fetchpatch {
        url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/commit/160879d7741e2d10e28920a3fedf04c44e35ebf2.patch";
        hash = "sha256-kOG1tq0Z5E5SawBATzyy09fOHlJO9CfW380BsSt+5ns=";
      })
      (prev.fetchpatch {
        url = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-amdgpu/-/commit/dfe74c0d6fd8d31e14a057bcac821372adfb5b52.patch";
        hash = "sha256-0uRM/dmf1sWXvNsAVB+DLx+fEey1NP2UR5sOa/+eqKY=";
      })
    ];
  });
}