final: prev: {
  aero-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "aerothemeplasma";
    rev = "1a949b8e5ee0c4199c1347fa472a4b1b6639ac5b";
    hash = "sha256-I8uHpXRpS1zNe/grjdgxL0mMVP0Av/XM1Pew/QYm+bI=";
  };
  aero-icons-repo = prev.fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "atp/aerothemeplasma-icons";
    rev = "44dbe78b76c8b0d55343428b6b179716c36fd7f6";
    hash = "sha256-jBTUgLpxhT/tVB5JTeAcxJ8zNyAK8gffGAiq3fOF1LE=";
  };
  aero-sounds-repo = prev.fetchFromGitLab {
    domain = "gitgud.io";
    owner = "aeroshell";
    repo = "atp/aerothemeplasma-sounds";
    rev = "4926188adcfed7ee699b53d3fb88e1996d67543d";
    hash = "sha256-nGZtC0cC0hBWIX0zkwsdQ4klGhCy6KuEajvxtKH7Q0Q=";
  };
  aero-libplasma-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "aeroshell-libplasma";
    rev = "a4e0bcc9e01434e5680070197e0e217ba50699c8";
    hash = "sha256-VD7R45o7HvhgYpHZ1NvtDP7hd68qj+h2gLTok11v4J4=";
  };
  aero-workspace-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "aeroshell-workspace";
    rev = "ceb31c1d4aac43955e0195c627a57bf45f511990";
    hash = "sha256-nVuO+MioCku/isljfRQgEv2sRclOF/QdPBNPZs6Kd6M=";
  };
  aero-kwin-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "aeroshell-kwin-components";
    rev = "326214ef964d24307fdf4482b61ee2001f4d9541";
    hash = "sha256-WOzYDtrIgNQwtifDNbOun324WvKFWcuuvdrG15gOAok=";
  };
  aero-smod-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "aeroshell-smod";
    rev = "1318dfde7ad028a7c95877a8f53e76af57034933";
    hash = "sha256-PeehinRWMsboxCjUpkDlkNSSYnR4Jl106SPkVb3aNEQ=";
  };
  uac-polkit-agent-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "uac-polkit-agent";
    rev = "4556c66edff23399c6be0915b6a98c125d9932e5";
    hash = "sha256-FwlICx2ZBpRgkWUtkIvXXvZFIPqTIr4eAqq43WHPZ8Q=";
  };
  plymouth-vista-repo = prev.fetchFromGitHub {
    owner = "rustussy";
    repo = "plymouth-vista";
    rev = "7c6d86524f53821f2b531ed4bc0444e0a3184d80";
    hash = "sha256-5HV3OS0PKcgh2HjKVkazkWdrubjm/rMSSQWaE/twPe0=";
  };
}
