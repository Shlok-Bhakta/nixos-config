{ config, pkgs, inputs, ... }: {

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # Bootloader.
  # boot.loader.grub.useOSProber = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  environment.sessionVariables = {
    NH_FLAKE = "/home/shlok/nixos-config";
  };
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  boot.kernelPackages = pkgs.linuxPackages_6_12;

 # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # driSupport = true; apparently not allowed anymore
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
      vdpauinfo
      libva
      libva-utils
    ];
  };

  security.polkit.enable = true;

  # Fix sudo permissions
  security.sudo = {
    enable = true;
    # execWheelOnly = true;
    # wheelNeedsPassword = false;
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
  };

  users.users.shlok = {
    isNormalUser = true;
    description = "Shlok Bhakta";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "dialout" "uinput" "libvirtd" "input" "adbusers"];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 
      53317
      5173
      8080
      80
      443
    ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };
  # networking.firewall.allowedUDPPorts = [ 
  #   1714
  #   1764
  #  ];

}
