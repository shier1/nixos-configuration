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