# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, self, ... }:

let
  legionModule = config.boot.kernelPackages.callPackage ./lenovo-legion-module.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./vm.nix
    ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.andrei = import ./home.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "andrei" ];

  # fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  services.flatpak.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  services.logind.settings.Login = {
    HandleLidSwitch = "lock";
    HandlePowerKey = "ignore";
    HandleLidSwitchDocked = "lock";
  };

  services.udisks2.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "andrei";
      };
      default_session = initial_session;
    };
  };

  # environment.loginShellInit = ''
  #   if uwsm check may-start; then
  #     exec uwsm start hyprland-uwsm.desktop
  #   fi
  # '';
  
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  # virtualisation.vmware.host.enable = true;
  # virtualisation.vmware.host.package = pkgs.vmware-workstation.overrideAttrs (_: {
  #   src = /nix/store/pvaa1sy0rdlhmkjsqvh0c27jbfsn4gj3-VMware-Workstation-Full-17.6.4-24832109.x86_64.bundle;
  # });

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  virtualisation.docker.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;

    open = true;
    nvidiaSettings = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "595.58.03";
    sha256_64bit = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
    sha256_aarch64 = "sha256-hzzIKY1Te8QkCBWR+H5k1FB/HK1UgGhai6cl3wEaPT8=";
    openSha256 = "sha256-6LvJyT0cMXGS290Dh8hd9rc+nYZqBzDIlItOFk8S4n8=";
    settingsSha256 = "sha256-2vLF5Evl2D6tRQJo0uUyY3tpWqjvJQ0/Rpxan3NOD3c=";
    persistencedSha256 = "sha256-AtjM/ml/ngZil8DMYNH+P111ohuk9mWw5t4z7CHjPWw=";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ libva-vdpau-driver ];
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:5:0:0";
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

# boot = {
#    kernelPackages = pkgs.linuxPackages_xanmod_latest;
#  };

  boot.kernelPackages = let
    linux_bpf_pkg = { fetchurl, buildLinux, ... } @ args:
    buildLinux (args // rec {
        version = "7.0.0";
        modDirVersion = "7.0.0";

        src = fetchurl {
            # url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.11.tar.xz";
            # sha256 = "sha256-IAOde2slbAi+L4+sQ8P/mmIDCMcDxkPPL4DDkQub1Zs=";
            url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.tar.xz";
            sha256 = "sha256-u39tgLOHx1e30Uu5MCj8uQ95PFwNNnc27oFaEAs4kfA=";
        };

        # kernelPatches = [
        #   { name = "prjc.patch"; patch = ./patches/0009-prjc.patch; }
        #   { name = "glitched-base.patch"; patch = ./patches/0003-glitched-base.patch; }
        #   { name = "glitched-cfs.patch"; patch = ./patches/0003-glitched-cfs.patch; }
        #   { name = "glitched-eevdf-additions.patch"; patch = ./patches/0003-glitched-eevdf-additions.patch; }
        #   { name = "clear-patches.patch"; patch = ./patches/0002-clear-patches.patch; }
        #   { name = "misc-additions.patch"; patch = ./patches/0012-misc-additions.patch; }
        # ];

        # extraConfigFromFile = /etc/nixos/linux-tkg/linux-tkg-config/6.19/config.x86_64;
        extraConfig = ''
        CONFIG_BPF y
        CONFIG_BPF_SYSCALL y
        # [optional, for tc filters]
        CONFIG_NET_CLS_BPF m
        # [optional, for tc actions]
        CONFIG_NET_ACT_BPF m
        CONFIG_BPF_JIT y
        # [for Linux kernel versions 4.7 and later]
        CONFIG_HAVE_EBPF_JIT y
        # [optional, for kprobes]
        CONFIG_BPF_EVENTS y
        # Need kernel headers through /sys/kernel/kheaders.tar.xz
        CONFIG_IKHEADERS y

        CONFIG_NET_SCH_SFQ m
        CONFIG_NET_ACT_POLICE m
        CONFIG_NET_ACT_GACT m
        CONFIG_DUMMY m
        CONFIG_VXLAN m
        '';

        ignoreConfigErrors = true;

        extraMeta.branch = "7.0.0";
  } // (args.argsOverride or {}));
    linux_bpf = pkgs.callPackage linux_bpf_pkg{};
  in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_bpf);

# # programs.hyprland = {
##  enable = true;
##  withUWSM = true;
##  xwayland.enable = true;
  # };

  # programs.xwayland.enable = true;

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    brave
    btop
    nvtopPackages.full  
    # bottles
    # (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    #   [General]
    #   background=${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/DarkestHour/contents/images/2560x1600.jpg
    # '')
    lutris
    lenovo-legion
    # linuxKernel.packages.linux_6_19.lenovo-legion-module
    lm_sensors
    # waybar
    # mako
    libnotify
    # swww
    # rofi
    networkmanagerapplet
    pavucontrol
    kitty
    blueman
    brightnessctl
    # nnn
    udiskie
    wl-clipboard
    grim
    slurp
    hyprlock
    hypridle
    remmina
    looking-glass-client
    hyprpaper
    zellij
    pywal
    powertop
    lm_sensors 
    killall
    devenv
    virt-v2v
    bibata-cursors
    direnv
    # emacs
    git
    ripgrep
    coreutils
    fd
    clang
    gnome-software
    gimp
    # winboat
    docker-compose
    # kdePackages.dolphin
    # kdePackages.qtsvg
    # kdePackages.kio
    # kdePackages.kio-fuse
    # kdePackages.kio-extras
    # alacritty
    fuzzel
    swaylock
    # mako
    swayidle
    xwayland-satellite
    noctalia-shell
    noctalia-qs
    adw-gtk3
    nwg-look
    kdePackages.qt6ct
    seahorse
    tuigreet
    openvpn
    lazygit
    horcrux
    protonup-qt
    zenity
    fzf
    dragon-drop
  ];

  programs.niri = {
    enable = true;
  };

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    greetd-password.enableGnomeKeyring = true;
  };

  programs.yazi.enable = true;

  services.earlyoom = {
    enable = true;
    freeSwapThreshold = 2;
    freeMemThreshold = 2;
    extraArgs = [
        "-g" "--avoid" "^(hyprland|waybar|kitty|systemd|virt-manager|virt-viewer|libvirtd|virtqemud|qemu-system.*)$"
        "--prefer" "^(brave|electron|chromium|libreoffice|gimp|steam)$"
    ];
  };

  hardware.bluetooth = {
    enable = false;
  };

  # services.tuned.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  # boot.extraModulePackages = with config.boot.kernelPackages;
  #  [ legionModule ];
  boot.extraModulePackages = [ legionModule ];
  
  boot.initrd.kernelModules = [
    # "vfio_pci"
    # "vfio"
    # "vfio_iommu_type1"

    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"

    "lz4"
  ];

  boot.initrd.systemd.enable = true;

  boot = {
    kernelModules = [ 
      "legion-laptop"
      "ntsync"
      "kheaders"
    ];
    
    kernelParams = [
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=lz4" # compression algorithm
      "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure

      # "amd_iommu=on"
      # "vfio-pci.ids=10de:2560,10de:228e"

      # "usbcore.autosuspend=-1"
      # "amdgpu.dcdebugmask=0x400"
      # "amdgpu.sg_display=0"

      # "snd_hda_intel.dmic_detect=0"
      # "snd_hda_intel.enable_msi=1"
    ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/andrei/.steam/root/compatibilitytools.d";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  programs.gamemode.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.pipewire.extraConfig.pipewire."92-stable-buffer" = {
    context.properties = {
      # default.clock.allowed-rates = [ 44100 48000 ];
      # default.clock.rate = 48000;
      default.clock.quantum = 1024;
      # default.clock.min-quantum = 1024;
      # default.clock.max-quantum = 4096;
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrei = {
    isNormalUser = true;
    description = "andrei";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  # programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 25565 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # networking.extraHosts = ''
  #   192.168.17.128 www.badstore.net
  # '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
