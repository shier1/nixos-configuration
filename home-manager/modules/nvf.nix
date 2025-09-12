{confg, pkgs, ...}:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };
        lineNumberMode = "number";
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;
        git.gitsigns.enable = true;

        filetree.neo-tree = {
          enable = true;
          setupOpts.enable_cursor_hijack = true;
        };

        binds.whichKey = {
          enable = true;
        };

        clipboard = {
          enable = true;
          providers.xclip.enable = true;
        };

        tabline.nvimBufferline = {
          enable = true;
          mappings = {
            closeCurrent = "<leader>q";
            cycleNext = "<leader>l";
            cyclePrevious = "<leader>h";
          };
        };

        languages = {
          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          clang = {
            enable = true;
            cHeader = true;
            lsp.enable = false;
            treesitter.enable = true;
          };
          bash = {
            enable =true;
            extraDiagnostics.enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
        };

        keymaps = [
          {
            key = "<C-h>";
            mode = "n";
            silent = true;
            action = "<C-w>h";
          }
          {
            key = "<C-l>";
            mode = "n";
            silent = true;
            action = "<C-w>l";
          }
          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = ":Neotree toggle<CR>";
          }
          {
            key = "<leader>m";
            mode = "n";
            silent = true;
            action = ":Glow<CR>";
          }
          {
            key = "m";
            mode = "n";
            silent = true;
            action = ":Glow!<CR>";
          }
        ];
        options = {
          shiftwidth = 4;
          tabstop = 4;
          expandtab = true;
          autoindent = true;
          smartindent = true;
        };
        extraPlugins = with pkgs.vimPlugins;{
          glow = {
            package = glow-nvim;
            setup = ''
              require('glow').setup({
                style = "dark",
                width = 120,
              })
            '';
          };
        };
      };
    };
  };
}
