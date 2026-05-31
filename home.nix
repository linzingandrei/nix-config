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

  # xdg = {

  #   portal = {
  #     enable = true;

  #     extraPortals = with pkgs; [
  #       # xdg-desktop-portal-wlr
  #       xdg-desktop-portal-gtk

  #       # kdePackages.xdg-desktop-portal-kde
  #       # xdg-desktop-portal-kde
  #     ];

  #     config = {
  #       # to find XDG files : got to the {hash} of the new version and find file named xdg-desktop*
  #       # .services files are located : /etc/profiles/per-user/...{user}.../share/systemd/user

  #       # pattern :
  #       # {name} -> "{name}-" -> {name}-portals.conf file

  #       # common -> empty -> portals.conf file
  #     };
  #   };
  # };


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

    shellAliases = {
      ghidra = "_JAVA_AWT_WM_NONREPARENTING=1 ghidra";
    };
  };
}
