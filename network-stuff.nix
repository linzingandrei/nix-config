{ config, lib, pkgs, ... }:

{
  services.opensnitch.enable = true;

  home-manager.users.myuser = {
    services.opensnitch-ui.enable = true;
  };
}
