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
  vim.languages.python.enable = true;

  # setup colorscheme 🎨
  vim.extraPlugins = with pkgs.vimPlugins; {
    catppuccin = {
      package = catppuccin-nvim;
      setup = # lua
        ''
          require("catppuccin").setup({
            flavour = "mocha",
          })
        '';
    };
    #    supermaven = {
    #package = supermaven-nvim;
    #setup = # lua
    #''
    #     require("supermaven-nvim").setup({})
    #   '';
    #}; 
    vim-visual-multi = {
      package = vim-visual-multi;
    };
  };
  vim.visuals.nvim-web-devicons.enable = true;

  vim.luaConfigRC.applyTheme =
    lib.nvim.dag.entryAnywhere # lua
      ''
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
    sources = {
      buffer = "[Buffer]";
      nvim-cmp = null;
      path = "[Path]";
    };
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

  # Setup Colorizer for showig # colors
  vim.ui.colorizer = {
    enable = true;
    setupOpts = {
      filetypes = {
        "*" = {
          "AARRGGBB" = true;
          "RGB" = true;
          "RRGGBB" = true;
          "RRGGBBAA" = true;
          "css" = true;
          "css_fn" = true;
          "hsl_fn" = true;
          "names" = true;
        };
      };
    };
  };

  # setup Comment tooling
  vim.comments.comment-nvim = {
    enable = true;
  };

  # Enable Surround
  vim.utility.surround = {
    enable = true;
    useVendoredKeybindings = false;
  };


  # Setup a Tabline
vim.tabline.nvimBufferline = {
  enable = true;
  mappings.closeCurrent = "<leader>bx";
  
  setupOpts = {
    options = {
      separator_style = "slant";
      diagnostics = "nvim_lsp";
      diagnostics_update_in_insert = false;
      show_buffer_icons = true;
      show_buffer_close_icons = true;
      show_close_icon = false;
      show_tab_indicators = true;
      color_icons = true;
      
      # Compact sizing for minimal vertical space
      tab_size = 16;
      max_name_length = 16;
      max_prefix_length = 12;
      
      indicator = {
        style = "icon";
      };
      style_preset = "minimal";
      numbers = "none";
      sort_by = "extension";
      modified_icon = "●";
      always_show_bufferline = true;
      auto_toggle_bufferline = true;
    };
  };
};

}
