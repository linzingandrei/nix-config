{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      opensnitch = prev.opensnitch.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./fix.patch
        ];
      });
    })
  ];

  services.opensnitch.enable = true;

  home-manager.users.andrei = {
    services.opensnitch-ui.enable = true;
  };
}
