# Configuration for generic system stuff
{ config, pkgs, ... }:


{

  networking.hostName = "LD-NixOS-PC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # necessary for VPN
  networking.iproute2.enable = true;
  services.mullvad-vpn.enable = true;

  # printing setup
  
  ## Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cups-brother-hll2350dw ];

  ## IPP auto discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };



}
