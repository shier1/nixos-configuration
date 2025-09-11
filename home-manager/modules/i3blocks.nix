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
        cpu_usage = {
          interval = 10;
          command = "~/.config/i3blocks/i3blocks-scripts/cpu-usage";
          LABEL = "CPU";
          T_WARN = 50;
          T_CRIT = 80;
          DECIMALS = 2;
          COLOR_NORMAL = "#EBDBB2";
          COLOR_WARN = "#FFFC00";
          COLOR_CRIT = "#FF0000";
        };
        temperature = {
          command = "~/.config/i3blocks/i3blocks-scripts/temperature";
          label = TEMP;
          interval = 10;
          T_WARN = 70;
          T_CRIT = 90;
          SENSOR_CHIP = "";
        };
        backlight = {
          command = "~/.config/i3blocks/i3blocks-scripts/xbacklight";
          label = "*";
          interva = 20;
          STEP_SIZE = 5;
          USE_SUDO = 0;
        };
        title = {
          interval = "persist";
          command = "${pkgs.xtitle}/bin/xtitle -s";
          format = " {title}";
          color = "#F8F8F2";
          max_width = 200;
        };
        time = {
          command = "date '+%H:%M'";
          interval = 60;
          format = " {time}";
          color = "#FFFFFF";
          background = "#6272A4";
        };
        date = lib.hm.dag.entryAfter [ "time" ] {
          command = "date '+%Y-%m-%d'";
          interval = 300;
          format = " {date}";
          color = "#F8F8F2";
        };
        systray = lib.hm.dag.entryAfter [ "date" ] {
          command = "echo ''";
          interval = "persist";
          color = "#FF79C6";
        };
      };
    };
  };
}