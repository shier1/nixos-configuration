{config, pkgs, ...}:
let 
  mmtui_mount = ''
    class mount(Command):
      """:mount.

      Show menu to mount and unmount.
      """

      MMTUI_PATH = "mmtui"

      def execute(self):
          """Show menu to mount and unmount."""
          import os
          import tempfile
          (f, p) = tempfile.mkstemp()
          os.close(f)
          self.fm.execute_console(
              f'shell bash -c "{self.MMTUI_PATH} 1> {p}"'
          )
          with open(p, 'r') as f:
              d = f.readline().strip()
              if os.path.exists(d):
                  self.fm.cd(d)
          os.remove(p)
      '';
  rangerWithMmtui = pkgs.ranger.overrideAttrs (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      cat >> $out/lib/python3.12/site-packages/ranger/config/commands.py <<EOF
    ${mmtui_mount}
    EOF
    '';
  });
in 
{
  programs.ranger = {
    enable = true;

    package = rangerWithMmtui;
    # plugin .../ranger/plugins/
    plugins = [
      {
        name = "devicons2";
        src = builtins.fetchGit {
          url = "https://github.com/cdump/ranger-devicons2.git";
          rev = "94bdcc19218681debb252475fd9d11cfd274d9b1";
        };
      }
    ];

    # .../ranger/rc.conf
    settings = {
      line_numbers = true;
      one_indexed = true;
      show_hidden = true;
      draw_borders = "both";
    };
    extraConfig = "default_linemode devicons2";
    # mapping .../ranger/rc.conf
    mappings = {
      X = "quitall_cd_wd ...";
    };
  };

  # ranger quitall_cd_wd shell scripts
  programs.bash.bashrcExtra = ''
    function ranger {
      local quit_cd_wd_file="$HOME/.cache/ranger/quit_cd_wd"        # The path must be the same as <file_saved_wd> in map.
      #command ranger "$@"              # If you have already added the map to rc.conf
      # OR add `map X quitall_cd_wd ...` if you don't want to add the map in rc.conf
      command ranger --cmd="map X quitall_cd_wd $quit_cd_wd_file" "$@"
      if [ -s "$quit_cd_wd_file" ]; then
        cd "$(cat $quit_cd_wd_file)"
        true > "$quit_cd_wd_file"
      fi
    }
  '';
  home.sessionVariables  = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };
}
