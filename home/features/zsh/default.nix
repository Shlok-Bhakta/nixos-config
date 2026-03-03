{ lib, config, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      gnrs = "git add . && git commit -m \"update config\" && git push && sudo nixos-rebuild switch --flake \"${config.home.homeDirectory}/nixos-config\" | lolcat -f";
      nrs = "nh os switch | lolcat";
      C = "code";
      c = "code .";
      cn = "code ${config.home.homeDirectory}/nixos-config";
      cat = "bat";
      man = "batman";
      cd = "z";
      plz = "sudo";
      s = "sudo";
      tmuxhelp = ''echo "$(tput setaf 4)TMUX CHEATSHEET$(tput sgr0)
        $(tput setaf 4)---------------$(tput sgr0)
        $(tput bold)Prefix is Ctrl-e$(tput sgr0)

        $(tput setaf 2)PANES$(tput sgr0)
        prefix + s          Split horizontally
        prefix + v          Split vertically 
        prefix + h/j/k/l    Navigate panes
        prefix + x          Kill current pane
        prefix + q          Show pane numbers
        prefix + z          Toggle pane zoom
        Ctrl + h/j/k/l      Smart pane switching (works with vim)

        $(tput setaf 2)WINDOWS$(tput sgr0)
        prefix + c          Create new window
        prefix + n          Next window
        prefix + p          Previous window
        prefix + &          Kill window
        prefix + ,          Rename window
        prefix + number     Go to window by number
        prefix + l          Toggle last active window
        prefix + w          List windows

        $(tput setaf 2)SESSIONS$(tput sgr0)
        prefix + d          Detach from session
        prefix + $          Rename session
        prefix + s          List/switch sessions
        tmux ls            List sessions
        tmux attach -t 0   Attach to session 0
        tmux kill-session  Kill current session

        $(tput setaf 2)MISC$(tput sgr0)
        prefix + r          Reload tmux config
        prefix + [          Enter copy mode (use vim keys)
        prefix + ?          Show all keybindings"'';
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };
}
