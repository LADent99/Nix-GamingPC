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
  networking.firewall = {
    enable = true;

  };


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
    publish = {
      enable = true;
      userServices = true;
    };
    nssmdns4 = true;
    openFirewall = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
  };
  
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    # Force x11 for browser dock support
    ).overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/obs \
          --set GDK_BACKEND x11 --set QT_QPA_PLATFORM xcb
        '';
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
      obs-multi-rtmp
      obs-source-record
      obs-scale-to-sound
      obs-move-transition
      obs-livesplit-one
    ];
  };
  
  # More specific packages
  environment.systemPackages = with pkgs; [
  mangohud
  protonup-qt
  protontricks
  bottles
  lutris
  calibre
  heroic
  winetricks
  audacity
  (prismlauncher.override {
    additionalLibs = [ 
      libxtst
      libxt
      libxkbcommon
      libXinerama
      libxcb
    ];
    jdks = [
      graalvmPackages.graalvm-ce
      zulu8
      zulu17
      zulu
      temurin-jre-bin
    ];
  })
  (vscode-with-extensions.override {
    vscode = vscodium;
    vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      continue.continue
      vscodevim.vim
      james-yu.latex-workshop
      golang.go
      mkhl.direnv
      hashicorp.hcl
    ];
  })
  (texliveMedium.withPackages (
    ps: with ps;
    [
      ling-macros
      tree-dvips
      moderncv
      geometry
      fontawesome5
      xcharter
      fontaxes
      enumitem
      hyperref
      titlesec

    ]
  ))
  ollama-cuda # this is cached by my cachix and replaced with an overlay
  claude-code
  llama-cpp
  streamrip
  alsa-scarlett-gui
  scarlett2
  v4l-utils
  cameractrls-gtk4 
  monero-gui
  krita
  gimp
  shotcut
  ffmpeg
  lshw
  usbutils
  waywall
  glfw3-minecraft
  piper
  zip
  unzip
  r2modman
  kubernetes-helm
  binutils
  # sunshine
  ];

  # mouse DPI setings
  services.ratbagd.enable = true;

  # configure docker
  virtualisation.docker.rootless = {
    enable = true; 
    setSocketVariable = true;
  };
  virtualisation.docker.storageDriver = "btrfs";

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.direnv.enable = true;

}
