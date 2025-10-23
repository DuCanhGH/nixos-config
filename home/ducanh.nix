{ inputs, config, pkgs, ... }:
let
  agenixPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX9GXpxfnALHa8pO7G/FPJp+rHACXzaG6HQ11lOk+2/ ngoducanh2912@gmail.com";
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID5fRr8pqUXd9sVUgz4PBaiZN5h9tRHW0862zNYz1OiT 75556609+DuCanhGH@users.noreply.github.com";
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  home = {
    username = "ducanh";
    file = {
      ".ssh/agenix.pub" = {
        text = agenixPublicKey;
      };
      ".ssh/id_ed25519.pub" = {
        text = sshPublicKey;
      };
    };
    stateVersion = "24.11";
  };
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      ssh_ed25519 = {
        file =  "${inputs.secrets}/ssh_ed25519.age";
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      gpg_17143A = {
        file =  "${inputs.secrets}/gpg_17143A.age";
        path = "${config.home.homeDirectory}/.gnupg/17143A062925B84B.key";
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
    signing.signByDefault = true;
    signing.key = "17143A062925B84B";
    settings = {
      user = {
        name = "DuCanhGH";
        email = "75556609+DuCanhGH@users.noreply.github.com";
      };
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