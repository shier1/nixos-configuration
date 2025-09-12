{config, pkgs, ...}:

{
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
}