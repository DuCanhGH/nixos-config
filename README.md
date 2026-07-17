# Snowflakes

My personal NixOS and nix-darwin configuration.

## Downloading AI models

When `fetchFromHuggingFace` is used as such:

```nix
pkgs.homa.fetchFromHuggingFace {
  repo = "unsloth/Qwen3.6-35B-A3B-MTP-GGUF";
  file = "Qwen3.6-35B-A3B-UD-Q4_K_M.gguf";
  version = "5bc3e238d916f48a861bac2f8a1990a0e9b7e98d";
  hash = "";
}
```

run the following command to preload the model and get the hash:

```bash
nix store prefetch-file https://huggingface.co/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/resolve/5bc3e238d916f48a861bac2f8a1990a0e9b7e98d/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf?download=true --name "unsloth-Qwen3.6-35B-A3B-MTP-GGUF-Qwen3.6-35B-A3B-UD-Q4_K_M.gguf-5bc3e238d916f48a861bac2f8a1990a0e9b7e98d"
```

The name of the file follows the pattern `<owner>-<repo>-<file>-<version>`.

## Special thanks

- [WackyIdeas](https://github.com/WackyIdeas) and contributors for developing [AeroThemePlasma](https://gitgud.io/wackyideas/aerothemeplasma)
- [furkrn](https://github.com/furkrn) for developing [PlymouthVista](https://github.com/furkrn/PlymouthVista)
- [aean0x](https://github.com/aean0x/.dotfiles/tree/20a3dd32b3ddbd752c93c9f38e03e76dbbd3ce87/aerotheme) and [Rotlug](https://github.com/Rotlug/aerothemeplasma-nixos) for prior art in packaging AeroThemePlasma for NixOS
- [nyakase](https://github.com/nyakase/aerothemeplasma-nix) for prior art in packaging AeroThemePlasma for NixOS and being friendly
- [meowkatee](https://gitgud.io/meowkatee) and [nyakase](https://github.com/nyakase) for suggesting the use of `LD_PRELOAD` [on a merge request for AUR packages](https://gitgud.io/wackyideas/aerothemeplasma/-/merge_requests/11#note_1759476), though this is no longer used
