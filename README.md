# Snowflakes

My personal NixOS and nix-darwin configuration.

## Downloading AI models

When `fetchFromHuggingFace` is used as such:

```nix
pkgs.homa.fetchFromHuggingFace {
  repo = "${owner}/${repo}";
  file = "${file}";
  version = "${version}";
  hash = "";
}
```

run the following command to preload the model and get the hash:

```bash
nix store prefetch-file https://huggingface.co/$OWNER/$REPO/resolve/$VERSION/$FILE?download=true --name "$OWNER-$REPO-$FILE-$VERSION"
```

The name of the file follows the pattern `<owner>-<repo>-<file>-<version>`.

## Special thanks

- [WackyIdeas](https://github.com/WackyIdeas) and contributors for developing [AeroThemePlasma](https://gitgud.io/wackyideas/aerothemeplasma)
- [furkrn](https://github.com/furkrn) for developing [PlymouthVista](https://github.com/furkrn/PlymouthVista)
- [aean0x](https://github.com/aean0x/.dotfiles/tree/20a3dd32b3ddbd752c93c9f38e03e76dbbd3ce87/aerotheme) and [Rotlug](https://github.com/Rotlug/aerothemeplasma-nixos) for prior art in packaging AeroThemePlasma for NixOS
- [nyakase](https://github.com/nyakase/aerothemeplasma-nix) for prior art in packaging AeroThemePlasma for NixOS and being friendly
- [meowkatee](https://gitgud.io/meowkatee) and [nyakase](https://github.com/nyakase) for suggesting the use of `LD_PRELOAD` [on a merge request for AUR packages](https://gitgud.io/wackyideas/aerothemeplasma/-/merge_requests/11#note_1759476), though this is no longer used
