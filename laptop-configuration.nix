{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ideapielus"; # Define your hostname.
  #networking.networkmanager.enable = true;
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.networks = {
    "DNA-WLAN-2G-B7A0" = { psk = "oyashiro-sama"; };
    "DNA-WLAN-2G-32B8" = { psk = "7yrGallbk0I9Fw9wVDzqWxLelpM"; };
    "ylajerkko" = { psk = "bhCG6sYE"; };
  };

  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  services.xserver = {
    # videoDrivers = [ "nvidia" ];
    # using intel for now because nvidia crashes X
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';

    # Enable touchpad support.
    libinput.enable = true;
  };
}
