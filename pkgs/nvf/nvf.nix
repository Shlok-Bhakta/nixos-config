{ pkgs, lib, ... }:

{
  # explicit configuration 🔧
  vim.globals.mapleader = " ";
  vim.globals.maplocalleader = ",";
  # Set the tab size to 4 spaces
  vim.options = {
    tabstop = 2;
    expandtab = true;
    shiftwidth = 2;
  };

  # Languages 💬
  vim.languages.nix = {
    enable = true;
    format.enable = true;
    format.type = "nixfmt";
    treesitter.enable = true;
  };

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
        })
      '';
    };
    supermaven = {
      package = supermaven-nvim;
      setup = /* lua */ ''
        require("supermaven-nvim").setup({})
      '';
    };
    vim-visual-multi = {
      package = vim-visual-multi;
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

  # Setup Lualine 🔗
  vim.statusline.lualine = {
    enable = true;
  };

  # Setup Autocomplete with nvim-cmp 🔎
  vim.autocomplete.nvim-cmp = {
    enable = true;
  };

  # Setup autopairing
  vim.autopairs.nvim-autopairs = {
    enable = true;
  };

  # Setup a file explorer 📂
  vim.utility.oil-nvim = {
    enable = true;
  };

  # Setup Trouble 🚨
  vim.lsp.trouble = {
    enable = true;
  };
}
