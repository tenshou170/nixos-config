{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Boot configuration
  boot = {
    loader = {
      # Using systemd-boot as bootloader
      systemd-boot = {
        enable = true;
        editor = true;
        consoleMode = "auto";
        edk2-uefi-shell.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    # Kernel configuration, using CachyOS kernel
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    # Essential kernel modules loaded at boot
    kernelModules = [
      "vfio-pci"
      "ntsync"
      "zram"
    ];

    # Kernel boot parameters
    kernelParams = [
      "preempt=full"
      "nowatchdog"
      "quiet"
      "splash"
      "loglevel=3"
      "resume_offset=533760"
      "psi=1"
      "intel_iommu=on"
      "iommu=pt"
    ];

    # Kernel runtime parameters (sysctl)
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    # Hibernation & Power Management
    resumeDevice = "/dev/disk/by-uuid/14b6e8da-d76f-4d6d-af2d-199ef907585c";

    # initrd configuration
    initrd = {
      systemd = {
        enable = true;
        fido2.enable = true;

        # Low latency settings for real-time applications
        tmpfiles.settings = {
          "10-lowlatency" = {
            "/sys/class/rtc/rtc0/max_user_freq" = {
              w.argument = "128";
            };
            "/proc/sys/dev/hpet/max-user-freq" = {
              w.argument = "128";
            };
          };
        };
      };
    };

    # Extra modprobe config
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm ignore_msrs=1
    '';

    # Boot splash
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };

  # Sleep and hibernation behavior
  systemd.sleep.extraConfig = ''
    [Sleep]
    AllowSuspendThenHibernate=yes
    HibernateMode=shutdown
    HibernateDelaySec=3600
  '';

  # sched_ext configuration
  services.scx = {
    enable = true;
    scheduler = "scx_rustland";
  };
}
