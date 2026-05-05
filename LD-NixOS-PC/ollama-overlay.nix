{ pkgs, ollama-cache, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      ollama-cuda = ollama-cache.packages.${prev.stdenv.hostPlatform.system}.default;
      # openldap 2.6.13 has a broken syncreplication test on i686; skip checks only
      # for the i686 variant used by lutris's FHS env, leaving x86_64 untouched
      pkgsi686Linux = prev.pkgsi686Linux // {
        openldap = prev.pkgsi686Linux.openldap.overrideAttrs (_: { doCheck = false; doInstallCheck = false; });
      };
    })
  ];
}