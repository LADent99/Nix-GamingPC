{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users-and-groups.nix
      ./system-configuration.nix
      ./ollama-overlay.nix
      ./manual-packages
    ];
}