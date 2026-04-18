## Introduction
* This repo is a personal repo of nix configs for a general gaming setup
* The below instructions are super basic for getting started with nh + nix.  For better and more up to date instructions check out the nix + nh documentation

## Updating System
* This config uses the `nh` tool for easier handling of nix commands
* Most of the time you will be using `switch` as you want to update + activate the new version.
* rebuilding + activating after a config file change - will not pull upstream changes
    ```
    nh os switch
    ```
* Updating upstream packages
    ```
    nh os switch -u
    ```


* Useful snippet for finding required libs for a deb package
```
nix-shell -p binutils curl dpkg --run bash << 'EOF'
  mkdir -p /tmp/deb-inspect && cd /tmp/deb-inspect
  curl -L -o package.deb "https://files.digilent.com/Software/Waveforms/3.25.1/digilent.waveforms_3.25.1_amd64.deb"
  dpkg-deb -x package.deb .
  find . -type f -executable | xargs -I{} readelf -d {} 2>/dev/null | grep NEEDED | sort -u
EOF
```