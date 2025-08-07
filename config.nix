{pkgs, ...}: let
  nixgl = pkgs.nixgl;
  nixGLWrap = pkg: let
    bins = "${pkg}/bin";
  in
    pkgs.buildEnv {
      name = "nixGL-${pkg.name}";
      paths =
        [pkg]
        ++ (map
          (bin:
            pkgs.hiPrio (
              pkgs.writeShellScriptBin bin ''
                exec -a "$0" "${nixgl.nixGLIntel}/bin/nixGLIntel" "${bins}/${bin}" "$@"
              ''
            ))
          (builtins.attrNames (builtins.readDir bins)));
    };
in {
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    nerd-fonts.jetbrains-mono
    neovim
    emacs
    git
    # tmuxinator
    fd
    ripgrep
    qmk
    qmk-udev-rules
    pandoc
    bup
    ollama
    nextcloud-client
    gnome-frog
    wl-clipboard
    # for gpg pinentry
    gcr
    gnome-shell-extensions
    gnome-extension-manager
    firefox
    iamb
    nixgl.nixGLIntel
    yt-dlp
    mpv
    freetube
    foliate
    gimp
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "org/gnome/desktop/peripherals/trackball" = {
      scroll-wheel-emulation-button = 9;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Alacritty";
      command = "alacritty";
      binding = "<Super>Return";
    };

    "org/gnome/desktopwm/preferences" = {
      num-workspaces = 4;
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 22;
  };

  home.file = {
    ".config/alacritty/catppuccin/catppuccin-mocha.toml".source = ./alacritty/catppuccin/catppuccin-mocha.toml;
    ".config/iamb/config.toml".source = ./iamb/config.toml;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        "$schema" = "https://starship.rs/config-schema.json";
        scan_timeout = 10;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[](bold red)";
        };

        palette = "catppuccin_mocha";

        palettes = {
          catppuccin_mocha = {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#f38ba8";
            maroon = "#eba0ac";
            peach = "#fab387";
            yellow = "#f9e2af";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#89b4fa";
            lavender = "#b4befe";
            text = "#cdd6f4";
            subtext1 = "#bac2de";
            subtext0 = "#a6adc8";
            overlay2 = "#9399b2";
            overlay1 = "#7f849c";
            overlay0 = "#6c7086";
            surface2 = "#585b70";
            surface1 = "#45475a";
            surface0 = "#313244";
            base = "#1e1e2e";
            mantle = "#181825";
            crust = "#11111b";
          };
        };
      };
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;

      defaultCommand = "fd . --min-depth 1 --type f";
      changeDirWidgetCommand = "fd --type d";
      fileWidgetCommand = "fd . --min-depth 1 --type f";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      shellAliases = {
        vim = "nvim";
        ls = "ls -l --color=auto";
        mux = "tmuxinator";
        sudo = "sudo env PATH=$PATH";
      };

      shellGlobalAliases = {
        G = "| rg";
      };
    };

    alacritty = {
      enable = true;

      package = nixGLWrap pkgs.alacritty;

      settings = {
        general.import = [
          "~/.config/alacritty/catppuccin/catppuccin-mocha.toml"
        ];

        window = {
          padding = {
            x = 0;
            y = 0;
          };
          startup_mode = "Maximized";
        };

        font = {
          normal = {family = "JetBrainsMono Nerd Font";};
          size = 11;
        };

        window = {
          option_as_alt = "OnlyLeft";
        };

        env = {
          TERM = "xterm-256color";
        };
      };
    };

    tmux = {
      enable = true;

      baseIndex = 1;

      mouse = true;

      prefix = "C-Space";

      keyMode = "vi";

      terminal = "xterm-256color";

      tmuxinator.enable = true;

      sensibleOnTop = true;

      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_status_style "basic"
            set -g @catppuccin_window_current_text "#W"
            set -g @catppuccin_window_text "#W"
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left "#{E:@catppuccin_status_session}"
            set -g status-right "#{E:@catppuccin_status_directory}"
          '';
        }
      ];

      extraConfig = ''
        # set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        set-option -g renumber-windows on

        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        bind 'c' new-window -c "#{pane_current_path}"
      '';
    };

    firefox = {
      enable = true;

      package = pkgs.librewolf;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        SearchBar = "unified";

        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          "7esoorv3@alefvanoon.anonaddy.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
            installation_mode = "force_installed";
          };
          "tridactyl.vim@cmcaine.co.uk" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
            installation_mode = "force_installed";
          };
          "browserpass@maximbaz.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/browserpass-ce/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };

      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          settings = {
            "browser.search.defaultenginename" = "ddg";
            "browser.search.order.1" = "ddg";

            "signon.rememberSignons" = false;
            "widget.use-xdg-desktop-portal.file-picker" = 1;
            "browser.aboutConfig.showWarning" = false;
            "browser.compactmode.show" = true;
            "browser.cache.disk.enable" = false; # Be kind to hard drive

            # Firefox 75+ remembers the last workspace it was opened on as part of its session management.
            # This is annoying, because I can have a blank workspace, click Firefox from the launcher, and
            # then have Firefox open on some other workspace.
            "widget.disable-workspace-management" = true;
          };

          search = {
            force = true;
            default = "ddg";
            order = ["ddg"];
          };
        };
      };

      nativeMessagingHosts = with pkgs; [
        browserpass
        tridactyl-native
      ];
    };

    gpg.enable = true;

    browserpass = {
      enable = true;
      browsers = [
        "firefox"
        "librewolf"
        "chromium"
      ];
    };

    chromium = {
      enable = false;
      extensions = [
        # ublock-origin
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        # browserpass
        {id = "naepdomgkenhinolocfifgehidddafch";}
        # vimium
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
      ];
    };

    password-store = {
      enable = true;

      package = pkgs.pass-wayland;
    };

    gnome-shell = {
      enable = true;
      extensions = [{package = pkgs.gnomeExtensions.gsconnect;}];
    };

    bash.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
