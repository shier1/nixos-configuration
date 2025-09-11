{config, pkgs, ...}:

{
  programs.i3blocks = {
    enable = true;
    bars = {
      top = {
      };
      config = {
        workspaces = {
          # interval = "once";
          # command = "${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r 'map(select(.focused)) | .[0] | .name'";
          # format = " {name}";
          # color = "#FF79C6";
          # background = "#282A36";
          interval = "persist";
          command = ''
            ${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r 'map(select(.focused)) | .[0] | .name'
            ${pkgs.i3}/bin/i3-msg -t subscribe -m '[ "workspace" ]' | while read -r event; do
              if echo "$event" | ${pkgs.jq}/bin/jq -e '.change == "focus" or .change == "init" or .change == "empty"' >/dev/null; then
                ${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r 'map(select(.focused)) | .[0] | .name'
              fi
            done
          '';
          format = " {name}";
          color = "#FF79C6";
          background = "#282A36";
        };

        # 窗口标题（美化版）
        title = {
          interval = "persist";
          command = "${pkgs.xtitle}/bin/xtitle -s";
          format = " {title}";
          color = "#F8F8F2";
          max_width = 200;
        };
        # 时间显示（美化版）
        time = {
          command = "date '+%H:%M'";
          interval = 60;
          format = " {time}";
          color = "#FFFFFF";
          background = "#6272A4";
        };

        # 日期显示（美化版）- 在时间之后
        date = lib.hm.dag.entryAfter [ "time" ] {
          command = "date '+%Y-%m-%d'";
          interval = 300;
          format = " {date}";
          color = "#F8F8F2";
        };

        # 系统托盘图标（美化版）- 在日期之后
        systray = lib.hm.dag.entryAfter [ "date" ] {
          command = "echo ''";
          interval = "persist";
          color = "#FF79C6";
        };
      };
    };
  };
}