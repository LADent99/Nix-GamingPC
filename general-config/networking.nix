

{ config, pkgs, ... }:
{

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.enableAllFirmware = true;
  
  # Seems to be for capture cards, disabling 
  # hardware.mwProCapture.enable = true;

  # Bluetooth Support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings.General = {
      Experimental = true;
      Privacy = "device";
      JustWorksRepairing = "always";
      Class = "0x000100";
      FastConnectable = true;
    };
  };

  # Bluetooth Xbox controller
  hardware.xpadneo.enable = true; # Enable the xpadneo driver for Xbox One wireless controllers
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    # connect xbox controller
  };
}