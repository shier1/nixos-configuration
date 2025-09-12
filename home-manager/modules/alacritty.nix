{config, pkgs, ...}:
{
  programs.alacritty = {
    enable = true;
    # 自定义配置
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 13;
	    normal = {
          family = "JetBrainsMono Nerd Font";
	      style = "Regular";
	    };
	    bold = {
          family = "JetBrainsMono Nerd Font";
	      style = "Bold";
	    };
	    italic = {
          family = "JetBrainsMono Nerd Font";
	      style = "Italic";
	    };
      };
      general.import = [
        "${pkgs.alacritty-theme}/share/alacritty-theme/gruvbox_dark.toml"
      ];
      colors.draw_bold_text_with_bright_colors = true;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
}
