{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Virtualization services configuration
  virtualisation = {
    # KVM/QEMU virtualization with libvirt
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
    containers.enable = true;

    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };

    # Podman container runtime
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
        ipv6_enabled = true;
      };
    };
  };

  # Enable virt-manager GUI for VM management
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # QEMU virtualization tools
    qemu
    qemu_kvm
    qemu-user
    qemu-utils
    OVMFFull

    # VM guest management tools
    libguestfs-with-appliance
    python3Packages.guestfs

    # Tools
    distrobox
    swtpm
  ];
}
