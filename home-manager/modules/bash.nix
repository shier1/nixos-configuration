{config, pkgs, ...}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add extra appendix on .bashrc
    bashrcExtra = ''
    '';

    # TODO add alias 
    shellAliases = {
      vim = "nvim";
      n = "neofetch";
      ns = "nvidia-smi";
      r = "ranger";
      dact = "conda deactivate";
      act = "conda activate";
      envl = "conda env list";
      py = "proxychains";
    };
  };
}