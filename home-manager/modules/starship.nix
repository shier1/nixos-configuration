{config, pkgs, ...}:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      "$schema" = "https://starship.rs/config-schema.json";
      format = "$all$nix_shell$conda$lua$python$git_branch$git_commit$git_state$git_status$directory";
      character = {
        success_symbol = "[](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
    };
  };
}