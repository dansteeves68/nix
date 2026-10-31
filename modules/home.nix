{ machine, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.extraActivationPath = with pkgs; [ nix ];
  home.packages = [ ];
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];
  home.sessionVariables = {
    EDITOR = "hx";
    HOMEBREW_AUTO_UPDATE_SECS = 50000;
    VISUAL = "hx";
  };
  # home.stateVersion = "24.11";
  home.stateVersion = "26.05";
  programs = {
    home-manager.enable = true;
    awscli.enable = true;
    bat = {
      config = {
        theme = "Nord";
      };
      enable = true;
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "Nord";
      };
      themes = {
        Nord = ''
          theme[available_end]="#ECEFF4"
          theme[available_mid]="#88C0D0"
          theme[available_start]="#81A1C1"
          theme[cached_end]="#ECEFF4"
          theme[cached_mid]="#88C0D0"
          theme[cached_start]="#81A1C1"
          theme[cpu_box]="#4C566A"
          theme[cpu_end]="#ECEFF4"
          theme[cpu_mid]="#88C0D0"
          theme[cpu_start]="#81A1C1"
          theme[div_line]="#4C566A"
          theme[download_end]="#ECEFF4"
          theme[download_mid]="#88C0D0"
          theme[download_start]="#81A1C1"
          theme[free_end]="#ECEFF4"
          theme[free_mid]="#88C0D0"
          theme[free_start]="#81A1C1"
          theme[hi_fg]="#5E81AC"
          theme[inactive_fg]="#4C566A"
          theme[main_bg]="#2E3440"
          theme[main_fg]="#D8DEE9"
          theme[mem_box]="#4C566A"
          theme[net_box]="#4C566A"
          theme[proc_box]="#4C566A"
          theme[proc_misc]="#5E81AC"
          theme[selected_bg]="#4C566A"
          theme[selected_fg]="#ECEFF4"
          theme[temp_end]="#ECEFF4"
          theme[temp_mid]="#88C0D0"
          theme[temp_start]="#81A1C1"
          theme[title]="#8FBCBB"
          theme[upload_end]="#ECEFF4"
          theme[upload_mid]="#88C0D0"
          theme[upload_start]="#81A1C1"
          theme[used_end]="#ECEFF4"
          theme[used_mid]="#88C0D0"
          theme[used_start]="#81A1C1"
        '';
      };
    };
    eza = {
      colors = "auto";
      enableZshIntegration = true;
      enable = true;
    };
    fd.enable = true;
    gh.enable = true;
    git = {
      enable = true;
      ignores = [ ".DS_Store" ];
      settings = {
        branch.sort = "-committerdate";
        column.ui = "auto";
        diff.algorithm = "histogram";
        diff.colorMoved = "plain";
        diff.mnemonicPrefix = true;
        diff.renames = true;
        fetch.all = true;
        fetch.prune = true;
        fetch.pruneTags = true;
        push.autoSetupRemote = true;
        push.default = "simple";
        push.followTags = true;
        tag.sort = "version:refname";
        user.email = machine.git.email;
        user.name = machine.git.username;
      };
    };
    htop.enable = true;
    jq.enable = true;
    lsd = {
      enable = true;
      enableZshIntegration = true;
    };
    mcfly.enable = true;
    ripgrep.enable = true;
    ripgrep-all.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        AddKeysToAgent = "yes";
        Compression = false;
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        ForwardAgent = true;
        HashKnownHosts = false;
        ServerAliveCountMax = 3;
        ServerAliveInterval = 0;
        UseKeychain = "yes";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };
      # foo = {
      #   addKeysToAgent = "yes";
      #   forwardAgent = true;
      #   extraOptions = {
      #     UseKeychain = "yes";
      #   };
      # };
    };
    uv.enable = true;
    vim = {
      enable = true;
      plugins = [ pkgs.vimPlugins.nord-vim ];
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
      # flavors = {}; there is a nord flavor but needed?
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      defaultKeymap = "viins"; # emacs, vicmd, or viins
      # Rex terminal: keep its bin dir first in PATH (empty outside Rex, so not in sessionPath)
      initContent = ''
        if [[ -n "$REX_BIN_DIR" ]]; then
          export PATH="$REX_BIN_DIR:$PATH"
        fi
      '';
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignorePatterns = [ ];
        ignoreSpace = true;
        save = 10000;
        share = true;
        size = 10000;
      };
      prezto = {
        enable = true;
        caseSensitive = false;
        color = true;
        editor.keymap = "vi";
        # order of pmodules matters, see prezto documentation
        pmodules = [
          "git"
          "prompt"
          "spectrum"
          "ssh"
          "terminal"
          "utility"
          "completion"
        ];
        prompt.theme = "steeef";
        ssh.identities = [
          "id_rsa"
          "id_rsa_bastion"
        ];
        terminal.autoTitle = true;
      };
      shellAliases = {
        cat = "bat";
        drs = ''darwin-rebuild switch --flake ".#$(uname -n)"'';
        ghrw = ''
          gh run watch $(gh run list --workflow lambda_on_push.yml --limit 1 --json databaseId --jq ".[0].databaseId")
        '';
        gst = "git status";
        gstg = "git stage";
        vi = "vim";
      };
      siteFunctions = {
        tfswitch = ''
          target_dir="$HOME/.terraform.d"
          link_name="$target_dir/credentials.tfrc.json"
          link_to="''${link_name}.''${1}"
          rm -f "$link_name"
          ln -s "$link_to" "$link_name"
          ls -l "$target_dir"
        '';
      };
      syntaxHighlighting.enable = true;
    };
  };
}
