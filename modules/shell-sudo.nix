{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Sudo configuration
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
    root ALL=(ALL:ALL) ALL
    tenshou170 ALL=(ALL:ALL) ALL
  '';

  # Default shell
  users.defaultUserShell = pkgs.zsh;

  # System packages
  environment.systemPackages = with pkgs; [
    # Fish plugins
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc

    # Zsh plugins
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting

    # Utilities
    bat
    eza
    fastfetch
    fd
    fzf
    grc
    msedit
    nano
    neovim
    pywal
    pciutils
    vim
    zenity
  ];

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # History settings
    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    # Oh My Zsh
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
      ];
      theme = "alanpeabody";
    };
  };

  # Fish shell
  programs.fish = {
    enable = true;
    vendor = {
      config.enable = true;
      functions.enable = true;
      completions.enable = true;
    };

    # Fish config
    shellInit = ''
      set -g fish_greeting ""
      set -g fish_key_bindings fish_vi_key_bindings
    '';
  };

  # Starship prompt - Modern, Minimal, & Nix-Integrated
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # minimal left-side prompt: directory > git > nix > tools > duration > line break > char
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$jobs"
        "$character"
      ];

      # Move language versions to the right to keep the main prompt clean
      # (Or move them back to 'format' if you prefer them on the left)
      right_format = lib.concatStrings [
        "$package"
        "$python"
        "$rust"
        "$golang"
        "$nodejs"
        "$lua"
        "$docker_context"
        "$terraform"
      ];

      # -----------------------------------------------------------------------
      # Core Integration: Nix Shell
      # -----------------------------------------------------------------------
      nix_shell = {
        disabled = false;
        heuristic = true;
        format = "[$symbol$state( \\($name\\))]($style) ";
        symbol = "❄️  ";
        style = "bold blue";
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
      };

      # -----------------------------------------------------------------------
      # Aesthetics & Symbols
      # -----------------------------------------------------------------------
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      fill = {
        symbol = " ";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        read_only = " 🔒";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "🏳";
        up_to_date = "";
        untracked = " ";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
        stashed = " ";
        modified = " ";
        staged = "[++\($count\)](green)";
        renamed = "襁 ";
        deleted = " ";
      };

      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };

      username = {
        show_always = false;
        style_user = "bold yellow";
        style_root = "bold red";
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) ";
        style = "bold green";
      };

      # -----------------------------------------------------------------------
      # Language Stacks (Minimal: No "via", "is", etc.)
      # -----------------------------------------------------------------------
      package = {
        symbol = "📦 ";
        format = "[$symbol$version]($style) ";
        style = "dimmed white";
      };

      python = {
        symbol = "🐍 ";
        format = "[$symbol$version(\($virtualenv\))]($style) ";
        style = "bold yellow";
      };

      rust = {
        symbol = "🦀 ";
        format = "[$symbol$version]($style) ";
        style = "bold red";
      };

      golang = {
        symbol = "🐹 ";
        format = "[$symbol$version]($style) ";
        style = "bold cyan";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
        style = "bold green";
      };

      lua = {
        symbol = "🌙 ";
        format = "[$symbol$version]($style) ";
        style = "bold blue";
      };

      docker_context = {
        symbol = "🐳 ";
        format = "[$symbol$context]($style) ";
        style = "blue bold";
      };
    };
  };
}
