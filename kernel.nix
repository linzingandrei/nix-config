{ pkgs }:

let
  linux_bpf_pkg = { fetchurl, buildLinux, ... } @ args:
    buildLinux (args // rec {
      version = "7.0.0";
      modDirVersion = version;

      src = fetchurl {
        # url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.19.11.tar.xz";
        # sha256 = "sha256-IAOde2slbAi+L4+sQ8P/mmIDCMcDxkPPL4DDkQub1Zs=";
        url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.tar.xz";
        sha256 = "sha256-u39tgLOHx1e30Uu5MCj8uQ95PFwNNnc27oFaEAs4kfA=";
      };

    # kernelPatches = [
    #   { name = "clear-patches.patch"; patch = ./tkg-config-and-patches/0002-clear-patches.patch; }

    #   { name = "glitched-base.patch"; patch = ./tkg-config-and-patches/0003-glitched-base.patch; }
    #   { name = "glitched-cfs.patch"; patch = ./tkg-config-and-patches/0003-glitched-cfs.patch; }
    #   { name = "glitched-eevdf-additions.patch"; patch = ./tkg-config-and-patches/0003-glitched-eevdf-additions.patch; }

    #   { name = "prjc.patch"; patch = ./tkg-config-and-patches/0009-prjc.patch; }

    #   { name = "misc-additions.patch"; patch = ./tkg-config-and-patches/0012-misc-additions.patch; }
    # ];

    # extraConfigFromFile = ./tkg-config-and-patches/config.x86_64;
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
  pkgs.linuxPackagesFor linux_bpf
