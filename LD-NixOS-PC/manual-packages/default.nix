{ config, pkgs, lib, ... }:

let
  adept2-runtime = pkgs.callPackage ./adept2-runtime.nix {};
  waveforms      = pkgs.callPackage ./waveforms.nix {
    inherit adept2-runtime;
  };
in
{
  # Install WaveForms for all users
  environment.systemPackages = [ waveforms];

  # Load the udev rules bundled in the adept2-runtime package
  # This grants your user permission to access the AD2 over USB
  services.udev.packages = [ adept2-runtime];
  # boot.blacklistedKernelModules = [ "ftdi_sio" ];

  environment.etc."digilent-adept.conf".text = ''
    DigilentPath=${adept2-runtime}/share/digilent/adept
    DigilentDataPath=${adept2-runtime}/share/digilent/adept/data
  '';
#   users.users.YOUR_USERNAME.extraGroups = [ "plugdev" ];
}