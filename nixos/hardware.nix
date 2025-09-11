{config, pkgs, ...}:

{
  # extra hardware settings
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    acpilight = {
      enable = true;
    };
    graphics = {
      enable = true;
    };
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      # use nvidia power manager may cause sleep/suspend to fail
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}