{ pkgs, lib, ... }:

{
  # explicit configuration 🔧
  vim.globals.mapleader = " ";
  vim.globals.maplocalleader = ",";


  # Languages 💬
  vim.languages.nix.enable = true;

  # General language options
  vim.languages.enableLSP = true;
  vim.languages.enableTreesitter = true;

  # setup colorscheme 🎨
  vim.extraPlugins = with pkgs.vimPlugins; {
    catppuccin = {
      package = catppuccin-nvim;
      setup = /* lua */ ''
        require("catppuccin").setup({
          flavour = "mocha",
          -- Add other Catppuccin options here if desired
        })
      '';
    };
  };
  vim.visuals.nvim-web-devicons.enable = true;

  vim.luaConfigRC.applyTheme = lib.nvim.dag.entryAnywhere /* lua */ ''
    vim.cmd('colorscheme catppuccin')
  '';


  # Setup Telescope 🔭
  vim.telescope = {
    enable = true;
  };

  # Setup WhichKey 🔑
  vim.binds.whichKey = {
    enable = true;
  };
}

