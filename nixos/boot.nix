{config, pkgs, ...}:

{
  # boot settings (use grub instead of bootloader)
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
}