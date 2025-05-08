# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users-and-groups.nix
      ./system-configuration.nix
      ./graphics-configuration.nix
    ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  git
  wget
  mangohud
  protonup
  protonup-qt
  bitwarden-desktop
  discord
  bottles
  lutris
  vscodium
  calibre
  kubectl
  tidal-hifi
  heroic
  winetricks
  nh
  ];

  environment.variables.EDITOR = "vim";
  
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\\\${HOME}/.steam/root/compatibilitytools.d";
    MOZ_ENABLE_WAYLAND = 1;
    NV_PRIME_RENDER_OFFLOAD = 1;
    NV_PRIME_RENDER_OFFLOAD_PROVIDER= "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    CLUTTER_DEFAULT_FPS = 165;
    __GL_SYNC_DISPLAY_DEVICE = "DP-1";
  };



  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.firefox.enable = true;
  programs.gamemode.enable = true;


}
