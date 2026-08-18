{ pkgs, ... }:

let
  poeLogout = pkgs.writeShellScriptBin "poe-hardcore-logout" ''
    exec ${pkgs.iproute2}/bin/ss -K dport 6112
  '';
in
{
  environment.systemPackages = [ poeLogout ];

  security.sudo.extraRules = [
    {
      users = [ "andrei" ];

      commands = [
        {
          command = "${poeLogout}/bin/poe-hardcore-logout";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
