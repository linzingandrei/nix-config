{ config, lib, pkgs, ... }:

{


  environment.systemPackages = with pkgs; [
    pkgs.cmake
    pkgs.gnumake
    pkgs.gcc

    pkg-config

    foot
    quickshell
    sox
    ffmpeg
    hypridle
    hyprlock
    nerd-fonts.martian-mono

    pkgs.hyprcursor
    pkgs.hyprland
    pkgs.hyprgraphics
    pkgs.libdrm
    pkgs.pixman
    pkgs.pango
    pkgs.aquamarine
    pkgs.hyprlang
    pkgs.hyprutils
    pkgs.libGL
    pkgs.libxkbcommon
    pkgs.libinput
    pkgs.wayland
    pkgs.wayland-protocols
    pkgs.wayland-scanner
    pkgs.wayland-utils
    pkgs.xorg.xcbutilwm
    pkgs.libxcb-errors

    pkgs.luajit
  ];
}
