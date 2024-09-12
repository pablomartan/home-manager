{pkgs, ...}: {
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
    (nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode"];})
    neovim
    git
    tmuxinator
    pass
    gnupg
    fd
    pass
    ripgrep
    qmk
    pandoc
    bup
    nixgl.nixGLIntel
  ];

  home.file = {
    ".config/alacritty/catppuccin/catppuccin-mocha.toml".source = ./alacritty/catppuccin/catppuccin-mocha.toml;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
  };

  home.shellAliases = {
    vim = "nvim";
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
        ls = "ls -lGh";
        v = "nvim";
        mux = "tmuxinator";
      };

      shellGlobalAliases = {
        G = "| rg";
      };
    };

    alacritty = {
      enable = true;

      settings = {
        import = [
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
          normal = {family = "FiraCode Nerd Font Mono";};
          size = 12;
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

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_status_modules_right "directory"
            set -g @catppuccin_status_modules_left "session"
            set -g @catppuccin_window_current_text "#{window_name}"
            set -g @catppuccin_window_default_text "#{window_name}"
          '';
        }
      ];

      extraConfig = ''
        unbind C-b
        set -g prefix C-Space
        bind C-Space send-prefix

        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        set -g mouse on

        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # set vi-mode
        set-window-option -g mode-keys vi

        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        bind 'c' new-window -c "#{pane_current_path}"
      '';
    };
  };
}