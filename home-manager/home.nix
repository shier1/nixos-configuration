{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = builtins.concatLists [
    [ ./packages.nix ]
    (import ./modules)
  ];
  # overlays settings
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # home settings
  home = {
    username = "shier";
    homeDirectory = "/home/shier";
  };
  
  # Cursor and screens dpi settings
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };


  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
