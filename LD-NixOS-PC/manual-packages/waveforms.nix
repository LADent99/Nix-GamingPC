{ config, pkgs, lib, stdenv, fetchurl, autoPatchelfHook, adept2-runtime, ... }:

stdenv.mkDerivation rec {
  pname   = "digilent-waveforms";
  version = "3.25.1";

  src = fetchurl {
    url  = "https://files.digilent.com/Software/Waveforms/${version}/digilent.waveforms_${version}_amd64.deb";
    # Run `nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url https://files.digilent.com/Software/Waveforms/${version}/digilent.waveforms_${version}_amd64.deb)` to verify/update this hash
    hash = "sha256-0peaq3JskgKkihxdKzFFMVExccC2L6Lyou3NKSAnJ9M="; # <-- replace
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    qt6.wrapQtAppsHook
    makeWrapper
  ];

#   buildInputs = with pkgs; [
#     adept2-runtime
#     qt6.qtbase
#     qt6.qtmultimedia
#     qt6.qtdeclarative
#     qt6.qt5compat
#     qt6.qtserialport
#     libGL
#     libGLU
#     libX11
#     libXext
#     libXrender
#     fontconfig
#     freetype
#     zlib
#     glib
#   ];

  buildInputs = with pkgs; [
    stdenv.cc.cc.lib
    adept2-runtime
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtdeclarative
    qt6.qtserialport
  ];

  unpackCmd  = "dpkg-deb -x ${src} .";
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild     = true;
  dontStrip     = true;  # proprietary binary – stripping will corrupt it

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    # WaveForms installs its libraries here
    if [ -d usr/lib/digilent/waveforms ]; then
      cp -r usr/lib/digilent/waveforms $out/lib/
    fi
    # Any top-level shared objects
    find usr/lib -maxdepth 1 -name '*.so*' -exec cp {} $out/lib/ \; 2>/dev/null || true

    # Desktop integration
    if [ -d usr/share ]; then
      cp -r usr/share/. $out/share/
    fi

    # fix hardcoded desktop path
    substituteInPlace $out/share/applications/digilent.waveforms.desktop \
      --replace '/usr/bin/waveforms' "$out/bin/waveforms"

    # Install the waveforms binary and wrap it so it can find its own libs
    install -Dm755 usr/bin/waveforms $out/bin/waveforms-unwrapped
    makeWrapper $out/bin/waveforms-unwrapped $out/bin/waveforms \
      --prefix LD_LIBRARY_PATH : "${adept2-runtime}/lib:$out/lib"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Digilent WaveForms – virtual instruments for Analog Discovery devices";
    homepage    = "https://digilent.com/reference/software/waveforms/waveforms-3/start";
    license     = licenses.unfree;
    platforms   = [ "x86_64-linux" ];
    maintainers = [];
  };
}