{ config, pkgs, ... }:

{
  home.username = "andrei";
  home.homeDirectory = "/home/andrei";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    vscode-fhs
    discord
    prismlauncher
    # emacs
    # neovim
    fd
    p7zip
    ntfs3g
    libreoffice-qt6-fresh
    usbutils
    obsidian
    poppler-utils
    zathura
    cemu
  ];

  programs.neovim = {
    enable = true;

    extraLuaConfig = ''
	vim.pack.add {
	    'https://github.com/nvim-treesitter/nvim-treesitter',
	    'https://github.com/neovim/nvim-lspconfig',
	    'https://github.com/stevearc/oil.nvim',
	}

	vim.g.mapleader = ','
	vim.opt.exrc = true
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.colorcolumn = '80'
	vim.opt.textwidth = 80
	vim.opt.completeopt = 'menu,menuone,fuzzy,noinsert'
	vim.opt.swapfile = false
	vim.opt.confirm = true
	vim.opt.linebreak = true
	vim.opt.termguicolors = true
    '';

    extraPackages = with pkgs; [
      lua-language-server
      nil
    ];
  };

  xdg = {
    portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-termfilechooser
      ];

      config = {
        # to find XDG files : got to the {hash} of the new version and find file named xdg-desktop*
        # .services files are located : /etc/profiles/per-user/...{user}.../share/systemd/user

        # pattern :
        # {name} -> "{name}-" -> {name}-portals.conf file

        # common -> empty -> portals.conf file
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.impl.portal.Inhibit" = [ "none" ];

          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };

        # wlroots -> "wlroots-" -> wlroots-portals.conf file
        wlroots = {
        };
      };
    };

    configFile = {
      "xdg-desktop-portal-termfilechooser/config" = {
        force = true;
        executable = true;
        text = ''
          [filechooser]
          cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          default_dir=$HOME/downloads
          create_help_file=1
          env=TERMCMD='kitty --title filechooser'
          env=PATH="$PATH:/run/current-system/sw/bin"
          open_mode=suggested
          save_mode=last
        '';
      };
    };

    desktopEntries.yazi = {
      name = "Yazi";
      exec = "kitty -e yazi";
      terminal = false;
      type = "Application";
      categories = [ "Utility" ];
    };
  };


  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 10;
      background_opacity = "0.8";
      background_blur = 5;
      extraConfig = ''
        tab_bar_style powerline
        cursor_trail 200
        cursor_trail_decay 0.1 0.4
        cursor_trail_start_threshold 2
      '';
    };
  };

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "$HOME/.zsh_history";

    sessionVariables = {
      DOOM = "doom";
      winboat = "/etc/nixos/flakes/winboat/result/bin/winboat";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
      theme = "flazz";
    };

    initExtra = ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d ''' cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }

      copyfile() {
        for f in "$@"; do
          printf 'file://%s\n' "$(realpath "$f")"
          done | wl-copy -t text/uri-list
      }
    '';

    shellAliases = {
      ghidra = "_JAVA_AWT_WM_NONREPARENTING=1 ghidra";
    };
  };


  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  programs.fzf.enableZshIntegration = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

  };
}
