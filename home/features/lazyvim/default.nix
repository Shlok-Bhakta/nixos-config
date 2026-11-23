{
  lib,
  pkgs,
  config,
  inputs,
  unstable,
  ...
}:
let
  skipStoreHelptags = ./skip-store-helptags.lua;

  lazyvimNvim = pkgs.writeShellApplication {
    name = "nvim";
    text = ''
      export NVIM_APPNAME=lazyvim
      exec ${lib.getExe config.programs.neovim.finalPackage} --cmd "luafile ${skipStoreHelptags}" "$@"
    '';
  };
in
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  # LazyVim tracks current Neovim; prefer unstable over the system pin.
  programs.neovim.package = lib.mkForce unstable.neovim-unwrapped;

  programs.lazyvim = {
    enable = true;
    # Isolated from home-manager's generated ~/.config/nvim.
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
        nix = {
          enable = true;
          installDependencies = true;
        };
        python = {
          enable = true;
          installDependencies = true;
        };
        rust.enable = true;
        sql.enable = true;
        tailwind.enable = true;
        typescript.enable = true;
        yaml.enable = true;
      };
      formatting.prettier.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      nixfmt
      statix
      pyright
    ];
  };

  home.packages = [
    (lib.hiPrio lazyvimNvim)
    (pkgs.writeShellApplication {
      name = "n";
      text = ''
        exec ${lib.getExe lazyvimNvim} "$@"
      '';
    })
  ];
}
