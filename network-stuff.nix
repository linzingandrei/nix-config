{ config, lib, pkgs, ... }:

{
  # programs.wireshark = {
  #   enable = true;

  #   package = pkgs.wireshark;

  #   dumpcap.enable = true;
  # };

  services.opensnitch.enable = true;

  home-manager.users.andrei = {
    services.opensnitch-ui.enable = true;
  };
}
