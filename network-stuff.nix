{ config, lib, pkgs, ... }:

{
  programs.wireshark = {
    enable = true;

    dumpcap.enable = true;
  };
}
