{ config, pkgs, ollama-cache, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users-and-groups.nix
      ./system-configuration.nix
    ];
}