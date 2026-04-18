{ config, pkgs, lib, stdenv, fetchurl, autoPatchelfHook, ... }:

stdenv.mkDerivation rec {
  pname   = "digilent-adept2-runtime";
  version = "2.30.1";
  src = fetchurl {
    url    = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}_amd64.deb";
    # Run `nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url <url>)` to verify/update this hash
    hash   = "sha256-5eUdJkDC/zTvO0NvO983g4EgsVFg1z37q4LpB3O2s3I=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
  ];

  # Runtime libraries the .so files link against
  buildInputs = with pkgs; [
    libusb1
    udev
    stdenv.cc.cc.lib   # provides libgcc_s.so.1 and libstdc++.so.6
    avahi
    openssl
  ];

  # Tell the generic unpack phase to use dpkg-deb instead of tar
  unpackCmd   = "dpkg-deb -x ${src} .";
  sourceRoot  = ".";

  dontConfigure = true;
  dontBuild     = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/lib/udev/rules.d

    # Libraries
    # Flatten all Digilent runtime .so files directly into $out/lib
    # so autoPatchelfHook in downstream packages can find them.
    find usr/lib/digilent/adept  -name '*.so*' -exec cp {} $out/lib/ \; 2>/dev/null || true
    find usr/lib64/digilent/adept -name '*.so*' -exec cp {} $out/lib/ \; 2>/dev/null || true
    find usr/lib -maxdepth 1 -name '*.so*' -exec cp {} $out/lib/ \; 2>/dev/null || true

    # udev helper binary - must live at $out/lib/udev/ to match the rules
    install -Dm755 usr/lib/udev/dftdrvdtch $out/lib/udev/dftdrvdtch

    # udev rules
    cp etc/udev/rules.d/*.rules $out/lib/udev/rules.d/ 2>/dev/null || true

    substituteInPlace $out/lib/udev/rules.d/*.rules \
        --replace 'RUN+="dftdrvdtch' "RUN+=\"$out/lib/udev/dftdrvdtch"

    # Data files
    if [ -d usr/share ]; then
        cp -r usr/share $out/share
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description  = "Digilent Adept 2 Runtime – required for WaveForms to communicate with Digilent USB devices";
    homepage     = "https://digilent.com/reference/software/adept/start";
    license      = licenses.unfree;
    platforms    = [ "x86_64-linux" ];
    maintainers  = [];
  };
}