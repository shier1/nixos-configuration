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
    ./user.nix
    ./i18n.nix
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
  networking.proxy.default = "socks://127.0.0.1:7897";
  networking.networkmanager.enable = true;

  # tomezone
  time.timeZone = "Asia/Shanghai";

  # fonts settings
  fonts.packages = with pkgs;[
     nerd-fonts.jetbrains-mono
  ];

  #docker
  virtualisation.docker.enable = true;

  system.stateVersion = "25.05";
}
