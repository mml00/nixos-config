{
  lib,
  pkgs,
  ...
}: let
  # keymap options
  options = {
    noremap = true;
    silent = true;
  };
in {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    luaLoader.enable = true;

    options = {
      completeopt = ["menu" "menuone" "noselect"];
      mouse = "a";

      # Tab
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;

      # UI config
      number = false;
      splitbelow = true;
      splitright = true;
      scrolloff = 8;
      sidescrolloff = 8;
      list = true;
      cmdheight = 0;
      listchars = {eol = "↵"; tab = "│ "; trail = "~"; extends = ">"; precedes = "<";};

      # Searching
      incsearch = true;
      hlsearch = true;
      ignorecase = true;
      smartcase = true;
      showmatch = true;
    };

    keymaps = [
      # { mode = "i"; key = "jk"; action = "<ESC>"; inherit options; }

      # resize
      { mode = "n"; key = "<C-Up>"; action = ":resize -1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Down>"; action = ":resize +1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Left>"; action = ":vertical resize -1<CR>"; inherit options; }
      { mode = "n"; key = "<C-Right>"; action = ":vertical resize +1<CR>"; inherit options; }

      # Save
      { mode = "n"; key = "fs"; action = ":write<CR>"; inherit options; }

      # Telescope
      { mode = "n"; key = "gf"; action = ":Telescope live_grep<CR>"; inherit options; }

      # Neotree
      { mode = "n"; key = "tn"; action = ":Neotree toggle<CR>"; inherit options; }

      # Visual mode
      { mode = "v"; key = "<"; action = "<gv"; inherit options; }
      { mode = "v"; key = ">"; action = ">gv"; inherit options; }
    ];

    # Highlight and remove extra white spaces
    highlight.ExtraWhitespace.bg = "red";
    match.ExtraWhitespace = "\\s\\+$";

    colorschemes.kanagawa = {
      enable = true;
      settings = {
        transparent = true;
      };
    };

    plugins = {
      better-escape = {
        enable = true;
        clearEmptyLines = true;
        mapping = [ "jk" ];
      };
      lsp = {
        enable = true;
        servers = {
          dockerls.enable = true;
          graphql.enable = true;
          html.enable = true;
          jsonls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          tsserver.enable = true;
          tailwindcss.enable = true;
          # vuels.enable = true;
          yamlls.enable = true;
        };
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
          { name = "nvim_lsp"; }
          # { name = "copilot"; }
          { name = "path"; }
          { name = "buffer"; }
          # { name = "luasnip"; }
          ];
          snippet = {
            expand = "luasnip";
          };
          formatting = {
            format = ''
            function(entry, vim_item)
              -- Kind icons
              local kind_icons = {
                Text = "",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰇽",
                Variable = "󰂡",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "󰅲",
              }

              vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
              -- Source
              vim_item.menu = ({
                  buffer = "[Buffer]",
                  copilot = "[Copilot]",
                  path = "[Path]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  })[entry.source.name]
              return vim_item
            end
            '';
          };
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm {
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                },

                ['<Tab>'] = function(fallback)
                  if not cmp.select_next_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                      cmp.complete()
                    else
                      fallback()
                    end
                  end
                end,

                ['<S-Tab>'] = function(fallback)
                  if not cmp.select_prev_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                      cmp.complete()
                    else
                      fallback()
                    end
                  end
                end,
              })
            '';
          };
        };
      };
      telescope = {
        enable = true;
        extensions = {
          # fzf-native = {
          #   enable = true;
          # };
        };
      };
      lualine = {
        enable = true;
        sections = {
          lualine_z = [ "%l/%L :%c" "%p%%" ];
        };
      };
      treesitter = {
        enable = true;
        indent = true;
        ensureInstalled = [
          "bash"
          "css"
          "fish"
          "html"
          "javascript"
          "json"
          "rust"
          "scss"
          "sql"
          "tsx"
          "typescript"
          "lua"
          "vim"
          "vimdoc"
          "python"
          "vue"
          "yaml"
          "hcl"
          "bash"
          "markdown"
          "graphql"
          "nix"
          "helm"
        ];
      };
      neo-tree = {
        enable = true;
        # filesystem.followCurrentFile = {
        #   enabled = true;
        #   leaveDirsOpen = true;
        # };
      };

      cmp-nvim-lsp.enable = true;
      cmp_luasnip.enable = true;
      luasnip.enable = true;
      # copilot-cmp.enable = true;
      # copilot-lua = {
      #   enable = true;
      #   panel.enabled = false;
      #   suggestion.enabled = false;
      #   filetypes =   {
      #     javascript = true; # allow specific filetype
      #     typescript = true; # allow specific filetype
      #     "*" = false; # disable for all other filetypes and ignore default `filetypes`
      #   };
      # };

      diffview.enable = true;
      notify.enable = true;
      indent-blankline.enable = true;
      ts-autotag.enable = true;
      nvim-autopairs.enable = true;
      nvim-colorizer.enable = true;
      comment.enable = true;
      ts-context-commentstring.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
    ];
    extraConfigLua = ''
      require('nvim-tmux-navigation').setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<M-h>",
          down = "<M-j>",
          up = "<M-k>",
          right = "<M-l>",
          -- last_active = "<C-\\>",
          -- next = "<C-Space>",
        }
      }

      function has_words_before()
        local cursor = vim.api.nvim_win_get_cursor(0)
        return vim.api.nvim_get_current_line():sub(1, cursor[2]):match('^%s$')
      end
    '';
  };
}
