{ pkgs, ... }:

{
  users.users = {
    irotnep = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel" "networkmanager"];
    };
  };
}
