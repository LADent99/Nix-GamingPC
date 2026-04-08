{ pkgs, ollama-cache, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      ollama-cuda = ollama-cache.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];
}