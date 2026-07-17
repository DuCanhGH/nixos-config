{ pkgs, ... }:
{
  fetchFromHuggingFace =
    {
      repo,
      file,
      version,
      hash,
    }:
    pkgs.fetchurl {
      inherit hash version;
      pname = "${repo}-${file}";
      url = "https://huggingface.co/${repo}/resolve/${version}/${file}?download=true";
    };
}
