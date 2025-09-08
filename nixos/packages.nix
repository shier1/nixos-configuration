{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    wget
    networkmanagerapplet
    git
    conda
    lua
    home-manager
  ];
}
