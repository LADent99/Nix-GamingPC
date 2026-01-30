
{ config, pkgs, ... }:


{
  # Create group for games
  users.groups.games = {};
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ladent = {
    isNormalUser = true;
    description = "Lucas";
    extraGroups = [ "networkmanager" "wheel" "games"];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "ladent"
    "@wheel"
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
    NH_OS_FLAKE = "/etc/nixos";
    KUBECONFIG = "/home/ladent/.kube_configs/home_cluster.yaml";
    SDL_JOYSTICK_HIDAPI = "0";
  };

}
