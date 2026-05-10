{ pkgs }:

let
  linux_tkg_pkg = { fetchurl, buildLinux, ... } @ args:
    buildLinux (args // rec {
      version = "7.0.5";
      modDirVersion = version;

      src = fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.0.5.tar.xz";
        sha256 = "sha256-ll+wocFnU5n8YMYGOyJ8BSMEG1+aZitmRi8SEsQ4rDw=";
      };

      kernelPatches = [
        { name = "bore.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0001-bore.patch; }

        { name = "clear-patches.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0002-clear-patches.patch; }

        { name = "glitched-base.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0003-glitched-base.patch; }
        { name = "glitched-cfs.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0003-glitched-cfs.patch; }
        { name = "glitched-eevdf-additions.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0003-glitched-eevdf-additions.patch; }

        { name = "prjc.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0009-prjc.patch; }

        { name = "misc-additions.patch"; patch = ./linux-tkg/linux-tkg-patches/7.0/patchwork/last-successful-check/0012-misc-additions.patch; }
      ];

      extraConfigFromFile = ./linux-tkg/linux-tkg-config/7.0/config.x86_64;

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

      extraMeta.branch = "7.0.5";
    } // (args.argsOverride or {}));
  linux_tkg = pkgs.callPackage linux_tkg_pkg{};
in
  pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_tkg)
