{ inputs, config, pkgs, ... }:
let
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5fRr8pqUXd9sVUgz4PBaiZN5h9tRHW0862zNYz1OiT 75556609+DuCanhGH@users.noreply.github.com";
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  home = {
    username = "ducanh";
    file = {
      ".ssh/id_ed25519.pub" = {
        text = sshPublicKey;
      };
    };
    stateVersion = "24.11";
  };
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    secrets = {
      # Somewhat meaningless, but we encrypt the SSH key used
      # to decrypt the `.age` files anyway...
      ssh_ed25519 = {
        symlink = true;
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        file =  "${inputs.secrets}/ssh_ed25519.age";
      };
      gpg_17143A = {
        symlink = true;
        path = "${config.home.homeDirectory}/.gnupg/17143A062925B84B.key";
        file =  "${inputs.secrets}/gpg_17143A.age";
      };
    };
  };
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };
  programs.git = {
    enable = true;
    userEmail = "75556609+DuCanhGH@users.noreply.github.com";
    userName = "DuCanhGH";
    signing.signByDefault = true;
    signing.key = "17143A062925B84B";
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