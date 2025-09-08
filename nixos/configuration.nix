{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  # boot settings (use grub instead of bootloader)
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };

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
  
  # overlays settings
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  # flake registry
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # hostname settings
  networking.hostName = "nixos";
  networking.proxy.default = "socks://127.0.0.1:7894";
  networking.networkmanager.enable = true;

  # tomezone
  time.timeZone = "Asia/Shanghai";

  # setting inputs
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs;[
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-nord
      ];
    };
  };

  # fonts settings
  fonts.packages = with pkgs;[
     nerd-fonts.jetbrains-mono
  ];

  # user settings
  users.users = {
    shier = {
      initialPassword = "root";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAckD0bD6Mvn2FFSqd1208+nd3NegUKoAltRu2qx70i1 zyanping@gmail.com"
      ];
      extraGroups = [ "networkmanager" "wheel" "docker" "bluetooth"];
    };
  };
  security.sudo.extraRules= [
    {
      users = [ "shier" ];
      commands = [
        {
	  command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];

  #docker
  virtualisation.docker.enable = true;
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

  system.stateVersion = "25.05";
}
