{ config, lib, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"uwsm start hyprland.desktop\"";
        user = "andrei";
      };
      default_session = initial_session;
    };
  };


  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandlePowerKeyLongPress = "poweroff";
  };

  environment.systemPackages = with pkgs; [
    grim
    swappy
    slurp

    kdePackages.dolphin

    hyprlauncher
    hyprlock
    hyprpaper
    hypridle

    qt5.qtwayland
    qt6.qtwayland

    kdePackages.qt6ct
    kdePackages.okular

    waybar
    networkmanager
    pavucontrol
    pulseaudio
    blueman
    peaclock
    playerctl
    swaynotificationcenter

    quickshell
  ];

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
    ];

    config = {
        common.default = [ "hyprland" "gtk" ];
        hyprland."org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
    };
  };
}
