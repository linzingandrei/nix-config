{ pkgs ? import <nixpkgs> {} }:

let
  kernelPackages = import ./kernel.nix { inherit pkgs; };

  legionApp = pkgs.callPackage ./lenovo-legion-app.nix {
    qtbase = pkgs.kdePackages.qtbase;
    wrapQtAppsHook = pkgs.qt6.wrapQtAppsHook;
  };

in
pkgs.callPackage ./lenovo-legion-module.nix {
  kernel = kernelPackages.kernel;
  inherit legionApp;
  kernelModuleMakeFlags = [];
}
