{ pkgs, ... }:

let
  poeLogout = pkgs.writeShellScriptBin "poe-hardcore-logout" ''
    if ! pgrep -af 'PathOfExile' >/dev/null 2>&1; then
      exit 0
    fi

    exec ${pkgs.iproute2}/bin/ss -K dport 6112
  '';
in
{
  environment.systemPackages = [ poeLogout ];

  security.sudo.extraConfig = ''
    andrei ALL=(root) NOPASSWD: ${poeLogout}/bin/poe-hardcore-logout
  '';
}
