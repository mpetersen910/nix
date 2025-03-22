# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').


{ config, pkgs, unstable ? pkgs, ... }:
{
  imports = [ 
  ];

  # Nix features
  nix = {
    settings.trusted-users = [ "mpete" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    # Uncomment if needed:
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Time and Locale
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  # Desktop environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    # Video drivers
  #  videoDrivers = [ "nvidia" ];
  };

  # NVIDIA configuration
 # hardware.nvidia = {
 #   package = config.boot.kernelPackages.nvidiaPackages.stable;
 #   nvidiaSettings = true;
 #   open = true;
 #   modesetting.enable = true;
 #   powerManagement.enable = true;
 # };


  
  hardware.graphics = {
    enable = true;
  };

  # Auto-login
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "mpete";
    };
  };

  # Workaround for GNOME autologin
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    # Uncomment if needed:
    # jack.enable = true;
  };
  services.pulseaudio.enable = false;

  # Printing
  services.printing.enable = true;

  # User configuration
  users.users.mpete = {
    isNormalUser = true;
    description = "mpete";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # Personal packages can go here
    ];
  };

  # Security
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 

  # System packages organized by category
  environment.systemPackages = with pkgs; [
    # Development tools
    vscode
    neovim
    vim
    jetbrains-toolbox
    git
    insomnia
    
    # Build tools
    gnumake
    cmake
    maven
    ninja
    pkg-config
    
    # Programming languages
    python3
    jdk21
    go
    go-tools
    nodejs
    nodePackages.rescript
    
    # Rust tools (consolidated)
    rustup
    rustc
    cargo
    rustfmt
    clippy

    # OCaml tools
    ocaml
    ocamlPackages.findlib
    ocamlPackages.dune_3
    ocamlPackages.utop
    ocamlPackages.merlin
    ocamlPackages.ocaml-lsp
    opam

    # C/C++ tools
    gcc
    clang
    libclang

    # System utilities
    coreutils
    findutils
    gnutar
    gnused
    gnugrep
    gawk
    wget
    htop
    ripgrep
    fd
    bat
    cmatrix

    # Libraries
    openssl
    openssl.dev
    zlib
    zlib.dev
    curl
    sqlite
    readline

    # Applications    
    chromium
    ghostty
    firefox

    # X11 and display libraries (removing duplicates)
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    bzip2
    cairo
    cups
    dbus
    dbus-glib
    desktop-file-utils
    expat
    flac
    fontconfig
    freeglut
    freetype
    fribidi
    fuse
    fuse3
    gdk-pixbuf
    glew110
    glib
    gmp
    gtk2
    harfbuzz
    icu
    libGL
    libGLU
    libcaca
    libcanberra
    libdbusmenu
    libdrm
    libjack2
    libjpeg
    libpng12
    libpulseaudio
    librsvg
    libthai
    libtiff
    libusb1
    libxkbcommon
    mesa
    pango
    vulkan-loader
    wayland
    
    # X.org packages (consolidated)
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXft
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libpciaccess
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xorg.xkeyboardconfig
  ];


  programs.chromium = {
     enable = true;
     extraOpts = {
     "browser.enabled_labs_experiments" = true;
     "BrowserSignin" = 0;
     "SyncDisabled" = true;
     "PasswordManagerEnabled" = false;
     "SpellcheckEnabled" = true;
     "ChromeVariations" = "no-experiments";
    };
  };

  security.chromiumSuidSandbox.enable = true;
  

  # Environment variables
  environment.variables = {
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };

  # In your configuration.nix or home.nix
  environment.shellAliases = {
    "ocaml-idea" = ''
      PATH="${pkgs.ocaml}/bin:${pkgs.opam}/bin:${pkgs.dune_3}/bin:$PATH" intellij-idea-ultimate
    '';


};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
