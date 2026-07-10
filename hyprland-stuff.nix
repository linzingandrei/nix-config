{ config, lib, pkgs, ... }:

{

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.
  };

  environment.systemPackages = with pkgs; [
    foot
    quickshell
    sox
    ffmpeg
    hypridle
    hyprlock
    nerd-fonts.martian-mono
  ];
}
