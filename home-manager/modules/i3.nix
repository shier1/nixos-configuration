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
            criteria = { class = "^Code$"; title = "^Open Folder$"; }; # for vscode open folder
            command = "floating enable, resize set 1000 800, move position center";
          }
        ];
      };
      assigns = {
        "10" = [{ class = "^Clash-verge$"; }];
        "1" = [{ class = "^Alacritty$"; }];
        "2" = [{ class = "^Microsoft-edge$"; }];
        "3" = [{ class = "^Code$"; }];
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
      bindsym Mod4+Tab workspace back_and_forth
    '';
  };
}