{config, pkgs, lib, ...}:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      # mod key, Mod4 = windows or command on the keyboard
      modifier = "Mod4";

      # keybindings for i3wm
      keybindings = 
        let 
          modifier = config.xsession.windowManager.i3.config.modifier;
        in 
          lib.mkOptionDefault {
            "${modifier}+Shift+Return" = "exec alacritty";
            "${modifier}+q" = "kill";
            "${modifier}+Shift+e" = "restart";
            "${modifier}+r" = "mod restart";
            "${modifier}+p" = "exec --no-startup-id rofi -show run";
          };
      window = {
        commands = [
          {
            criteria = {floating=true;}; # for all floating window
            command = "floating enable, resize set 800 px 600 px, move position center";
          }
          {
            criteria = { class = "^Code$"; title = "^Open Folder$"; }; # for vscode open folder
            command = "floating enable, resize set 800 600, move position center";
          }
        ];
      };
      assigns = {
        "1" = [{ class = "^Alacritty$"; }];
        "2" = [{ class = "^Microsoft-edge$"; }];
        "3" = [{ class = "^Code$"; }];
        "10" = [{ class = "^Clash-verge$"; }];
      };
      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
        }
      ];
      # startup = [];
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        style = "Regular";
        size = 7.0;
      };
    };
    extraConfig = ''
      bindsym $mod+Tab workspace back_and_forth
    '';

    programs.i3blocks = {
      enable = true;
      # bars
    };
  };
}