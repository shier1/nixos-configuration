{config, pkgs, ...}:

{
  # services

  # openssh settings
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  # blueman
  services.blueman.enable = true;

  # i3wm
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      variant = "";
    };
    desktopManager = {
      xterm.enable = false;
      runXdgAutostartIfNone = true;
    };
    windowManager.i3.enable = true;
  };
  services.displayManager.defaultSession = "none+i3";

  # systemd
  systemd.services.bluetooth = {
    after = [ "network.target" ];
    wants = [ "network.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = "3s";
  };
}