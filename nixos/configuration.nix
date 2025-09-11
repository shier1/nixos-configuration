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
    ./boot.nix
    ./hardware.nix
    ./service.nix
  ];
  
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

  system.stateVersion = "25.05";
}
