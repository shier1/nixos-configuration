{config, pkgs, lib, ...}:

{
  home.file = {
    ".config/i3blocks/i3blocks-scripts" = {
      source = ./i3blocks-scripts;
      recursive = true;
      executable = true;
    };
  };

  programs.i3blocks = {
    enable = true;
    bars = {
      config = {
        title = {
          interval = "persist";
          command = "${pkgs.xtitle}/bin/xtitle -s";
          label = " ";
          color = "#F8F8F2";
          max_width = 200;
        };
        backlight = lib.hm.dag.entryAfter[ "title" ]{
          command = "~/.config/i3blocks/i3blocks-scripts/xbacklight";
          label = "󱩔 ";
          interval = 20;
          STEP_SIZE = 5;
          USE_SUDO = 1;
        };
        cpu_usage = lib.hm.dag.entryAfter[ "backlight" ] {
          interval = 10;
          command = "~/.config/i3blocks/i3blocks-scripts/cpu-usage";
          LABEL = " ";
          T_WARN = 50;
          T_CRIT = 80;
          DECIMALS = 2;
          COLOR_NORMAL = "#EBDBB2";
          COLOR_WARN = "#FFFC00";
          COLOR_CRIT = "#FF0000";
        };
        time = lib.hm.dag.entryAfter[ "cpu_usage" ] {
          command = "date '+%H:%M'";
          interval = 60;
          label = "󱑁 ";
          color = "#FFFFFF";
          background = "#6272A4";
        };
        date = lib.hm.dag.entryAfter [ "time" ] {
          command = "date '+%Y-%m-%d'";
          interval = 300;
          label = " ";
          color = "#F8F8F2";
        };
        temperature = lib.hm.dag.entryAfter [ "date" ]{
          command = "~/.config/i3blocks/i3blocks-scripts/temperature";
          label = " ";
          interval = 10;
          T_WARN = 70;
          T_CRIT = 90;
          SENSOR_CHIP = "";
        };
        ipv4 = lib.hm.dag.entryAfter [ "temperature" ]{
          command = "~/.config/i3blocks/i3blocks-scripts/ip";
          interval = 10;
          label = "󰩟 ";
          color = "#FFFFFF";
        };
      };
    };
  };
}