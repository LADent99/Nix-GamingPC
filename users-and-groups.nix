
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
}
