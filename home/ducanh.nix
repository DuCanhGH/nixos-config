{ pkgs, ... }: {
  home.username = "ducanh";
  home.homeDirectory = "/home/ducanh";
  home.stateVersion = "24.11";
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  programs.git = {
    enable = true;
    userEmail = "ngoducanh2912@gmail.com";
    userName = "DuCanhGH";
    signing.signByDefault = true;
    extraConfig = {
      credential."https://github.com" = {
        helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
      credential."https://gist.github.com" = {
        helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };
      push.autoSetupRemote = true;
      core.editor = "vim";
      filter."lfs" = {
        process = "git-lfs filter-process";
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
      };
      http.postBuffer = 157286400;
      init.defaultBranch = "main";
    };
  };
}