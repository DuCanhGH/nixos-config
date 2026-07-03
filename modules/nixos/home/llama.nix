{ lib, config, ... }:
let
  cfg = config.programs.opencode;
in
{
  programs.opencode = lib.mkIf cfg.enable {
    settings = {
      provider = {
        "llama.cpp" = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-server (local)";
          options.baseURL = lib.mkDefault "http://127.0.0.1:8080/v1";
          models = {
            "Qwen/Qwen3.6-35B-A3B" = {
              name = "Qwen3.6-35B-A3B (local)";
              limit = {
                context = 131072;
                output = 32768;
              };
            };
          };
        };
      };
    };
  };
}
