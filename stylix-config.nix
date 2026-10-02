{ config, lib, pkgs, stylix, ... }:

{
  stylix = {
    enable = true;

    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml";

    opacity = {
      terminal = 0.85;
    };
  };
}
