# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./laptop-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz}/nixos")
    ];


  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    firefox
  ];

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # for nvidia
  nixpkgs.config.allowUnfree = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;

    layout = "fi";
    xkbVariant = "das";

    displayManager = {
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      configFile = "/etc/nixos/i3.conf";
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonazan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

  home-manager.users.joonazan = with pkgs; {
    home.packages = with pkgs; [
      (callPackage (builtins.fetchTarball {
        url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
      }) { doomPrivateDir = ./doom.d; })

      emacsPackages.proofgeneral_HEAD

      ripgrep

      rustup
      gcc
      binutils

      coq
      unison-ucm
      arduino

      tdesktop
    ];
    home.file.".emacs.d/init.el".text = ''
      (load "default.el")
    '';
    programs.git = {
      enable = true;
      userName = "Joonatan Saarhelo";
      userEmail = "joon.saar@gmail.com";
    };
  };
}
