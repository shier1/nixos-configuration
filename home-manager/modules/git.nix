{config, pkgs, ...}:
{
  programs.git = {
    enable = true;
    userName = "shier1";
    userEmail = "zyanping14@gmail.com";
    extraConfig = {
      credential.helper = "cache --timeout=86400"; # use git cache for saving the git's token, the time is 1 day
    };
  };
}