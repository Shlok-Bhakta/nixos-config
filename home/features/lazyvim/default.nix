{
  lib,
  pkgs,
  config,
  inputs,
  unstable,
  ...
}:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  # LazyVim tracks current Neovim; prefer unstable over the system pin.
  programs.neovim.package = lib.mkForce unstable.neovim-unwrapped;

  programs.lazyvim = {
    enable = true;
    # Keep ~/.config/nvim free for nvf; launch via `n` with NVIM_APPNAME.
    appName = "lazyvim";
    configFiles = ./config;

    extras = {
      lang = {
        clangd.enable = true;
        docker.enable = true;
        go.enable = true;
        java.enable = true;
        json.enable = true;
        markdown.enable = true;
        nix.enable = true;
        python.enable = true;
        rust.enable = true;
        sql.enable = true;
        svelte.enable = true;
        tailwind.enable = true;
        typescript.enable = true;
        yaml.enable = true;
      };
      formatting.prettier.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "n";
      text = ''
        export NVIM_APPNAME=lazyvim
        exec ${lib.getExe config.programs.neovim.finalPackage} "$@"
      '';
    })
  ];
}
