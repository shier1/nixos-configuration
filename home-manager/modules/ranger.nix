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
          ref = "master";
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
      q = "quitall_cd_wd";
    };
  };

  home.file.".config/ranger/plugins/quit_cd_wd.py" = {
    text = ''
      import os
      from ranger.api.commands import Command

      class quitall_cd_wd(Command):
          """:chdir to working directory of ranger after quitalling on ranger.

          """
          def _exit_no_work(self):
              if self.fm.loader.has_work():
                  self.fm.notify('Not quitting: Tasks in progress: Use `quitall!` to force quit')
              else:
                  self.fm.exit()

          def execute(self):
              self.save_wd()
              self._exit_no_work()

          def save_wd(self):
              if len(self.args) > 1:
                  wd_file_path=os.path.expanduser(self.arg(1))
              else:
                  wd_file_path=os.path.expanduser('~/.cache/ranger/quit_cd_wd')
              wd_dir_path = os.path.dirname(wd_file_path)
              if not os.path.exists(wd_dir_path):
                  os.makedirs(wd_dir_path)
              with open(wd_file_path, 'w') as f:
                  f.write(self.fm.thisdir.path);
    '';
    executable = true;
  };
  
  # ranger quitall_cd_wd shell scripts
  programs.bash.bashrcExtra = ''
    function ranger {
      local quit_cd_wd_file="$HOME/.cache/ranger/quit_cd_wd"        # The path must be the same as <file_saved_wd> in map.
      # command ranger "$@"              # If you have already added the map to rc.conf
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
