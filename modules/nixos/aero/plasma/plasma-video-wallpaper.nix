{
  pkgs,
  mkAeroDerivation,
}:

mkAeroDerivation {
  pname = "plasma-video-wallpaper";
  src = pkgs.repos.plasma-video-wallpaper;
}
