{config, pkgs, ...}:

{
  # user settings
  users.users = {
    shier = {
      initialPassword = "root";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAckD0bD6Mvn2FFSqd1208+nd3NegUKoAltRu2qx70i1 zyanping@gmail.com"
      ];
      extraGroups = [ "networkmanager" "wheel" "docker" "bluetooth"];
    };
  };
  security.sudo.extraRules= [
    {
      users = [ "shier" ];
      commands = [
        {
	  command = "ALL" ;
          options= [ "NOPASSWD" ];
        }
      ];
    }
  ];
}