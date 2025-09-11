{config, pkgs, ...}:
{
  home.packages = with pkgs;[
    neofetch
    feh
    zip
    unzip

    #misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix tool
    nix-output-monitor

    # productity
    glow        # markdown previewer in terminal

    # monitor
    htop        # thread monitor
    iotop       # io monitor
    iftop       # network monitor
    lsof        # open file monitor

    # system tools
    sysstat
    ethtool
    pciutils    # lspci
    usbutils    # lsusb

    # preview packages for ranger
    mmtui       # disk manager
    highlight   # code preview highlight

    # i3 extra packages
    rofi
    alsa-utils  # for the audio
    xtitle      # for the window title
    lm_sensors  # for the temperature

    
    # GUI
    clash-verge-rev
    microsoft-edge
    vscode
    wechat
    qq
    spotify
    nemo-with-extensions      # file manager gui
  ];
}