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
    relativenumber = true;
    number = true;
    ignorecase = true;
    smartcase = true;
  };

  # Languages 💬
  vim.languages = {
    enableTreesitter = true;
    nix = {
      enable = true;
      format.enable = true;
      format.type = "nixfmt";
      treesitter.enable = true;
    };
    python.enable = true;
    go = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    ts = {
      enable = true;
      format = {
        enable = true;
        type = "prettierd";
      };
      lsp.enable = true;
      treesitter.enable = true;
    };
    svelte = {
      enable = true;
      format = {
        enable = true;
        type = "biome";
      };
      lsp.enable = true;
      treesitter.enable = true;
    };
    html = {
      enable = true;
      treesitter.enable = true;
    };
    css = {
      enable = true;
      format = {
        enable = true;
        type = "prettierd";
      };
      lsp.enable = true;
      treesitter.enable = true;
    };
    tailwind = {
      enable = true;
      lsp.enable = true;
    };
    bash = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    clang = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    java = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    markdown = {
      enable = true;
      format = {
        enable = true;
        type = "prettierd";
      };
      lsp.enable = true;
      treesitter.enable = true;
    };
    sql = {
      enable = true;
      format.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    yaml = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
  };
  

  # General language options
  vim.lsp.enable = true;
  
  # Enable inline error diagnostics (like VSCode ErrorLens)
  vim.diagnostics = {
    enable = true;
    config.virtual_text = true;
  };

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
    vim-visual-multi = {
      package = vim-visual-multi;
    };
  };
  
  vim.binds.hardtime-nvim = {
    enable = true;
    setupOpts = {
      max_count = 4;
      restriction_mode = "hint";
      disabled_filetypes = ["qf" "netrw" "lazy" "mason" "oil" "TelescopePrompt"];
    };
  };
  
  vim.mini = {
    ai.enable = true;
    
    diff = {
      enable = true;
      setupOpts = {
        view = {
          style = "sign";
        };
      };
    };
    
    icons.enable = true;
    
    indentscope = {
      enable = true;
      setupOpts = {
        symbol = "│";
        ignore_filetypes = ["help" "neo-tree" "notify" "NvimTree" "TelescopePrompt" "oil"];
      };
    };
    
    jump2d = {
      enable = true;
      setupOpts = {
        mappings = {
          start_jumping = "<leader>/";
        };
      };
    };
    
    trailspace = {
      enable = true;
    };
    
    move = {
      enable = true;
    };
    
    cursorword = {
      enable = true;
    };
    
    notify = {
      enable = true;
    };
  };
  
  vim.visuals.nvim-web-devicons.enable = true;

  vim.luaConfigRC.applyTheme =
    lib.nvim.dag.entryAnywhere # lua
      ''
        vim.cmd('colorscheme catppuccin')
      '';
  vim.luaConfigRC.customKeybinds =
    lib.nvim.dag.entryAnywhere # lua
      ''
        vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
        vim.keymap.set('n', '<leader>e', ':e<CR>', { desc = 'Reload file' })
        
        vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left in insert mode' })
        vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down in insert mode' })
        vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up in insert mode' })
        vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right in insert mode' })
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

  # Setup Autocomplete with blink.cmp 🔎
  vim.autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    
    setupOpts = {
      keymap.preset = "default";
      
      sources = {
        default = [ "lsp" "path" "snippets" "buffer" ];
      };
      
      completion = {
        menu.auto_show = true;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
      };
    };
  };
  
  vim.autocomplete.enableSharedCmpSources = true;

  # Setup autopairing
  vim.autopairs.nvim-autopairs = {
    enable = true;
  };

  # Setup a file explorer 📂
  vim.utility.oil-nvim = {
    enable = true;
    setupOpts = {
      view_options = {
        show_hidden = true;
      };
    };
  };
  # Setup Trouble 🚨
  vim.lsp.trouble = {
    enable = true;
  };

  # Setup Git integration 🔀
  vim.git.gitsigns = {
    enable = true;
    codeActions.enable = true;
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
  
  mappings = {
    closeCurrent = "<leader>bx";
    cycleNext = "<Tab>";
    cyclePrevious = "<S-Tab>";
    pick = "<leader>bp";
  };

  setupOpts = {
    options = {
      separator_style = "thick";
      
      indicator = {
        style = "icon";
        icon = "▎";
      };
      
      modified_icon = "●";
      show_buffer_icons = true;
      show_buffer_close_icons = true;
      show_close_icon = false;
      color_icons = true;
      
      tab_size = 20;
      max_name_length = 18;
      
      always_show_bufferline = true;
      sort_by = "id";
      numbers = "none";
      
      diagnostics = "nvim_lsp";
      diagnostics_update_in_insert = false;
      
      left_mouse_command = "buffer %d";
      middle_mouse_command = "bdelete! %d";
    };
  };
};

}
