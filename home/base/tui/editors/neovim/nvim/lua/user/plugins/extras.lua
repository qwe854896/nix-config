return {
  "ThePrimeagen/vim-be-good",
  {
    'ojroques/nvim-osc52',
    config = function()
      require('osc52').setup()
      local function copy()
        if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
          require('osc52').copy_register('"')
        end
      end

      vim.api.nvim_create_autocmd('TextYankPost', { callback = copy })
    end
  },
  {
    'alker0/chezmoi.vim',
    lazy = false,
    init = function()
      -- This option is required.
      vim.g['chezmoi#use_tmp_buffer'] = true
      -- add other options here if needed.
    end,
    enabled = false,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require('neoscroll').setup {
        easing_function = "quadratic",
        pre_hook = function(info)
          if info == "cursorline" then
            vim.wo.cursorline = false
          end
        end,
        post_hook = function(info)
          if info == "cursorline" then
            vim.wo.cursorline = true
          end
        end,
      }
      local keyset = vim.keymap.set
      keyset("n", "n", "n:lua require('neoscroll').zz(300)<CR>", { silent = true })
      keyset("n", "N", "N:lua require('neoscroll').zz(300)<CR>", { silent = true })

      local t = {}
      local e = [['cursorline']]

      t['gg'] = { 'scroll', { '-2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
      t['G']  = { 'scroll', { '2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }

      require('neoscroll.config').set_mappings(t)
    end
  },
  {
    "LunarVim/bigfile.nvim",
    config = function()
      require('bigfile').setup {
        filesize = 2,
        pattern = { "*" },
        features = {
          "matchparen",
          "indent_blankline",
          "vimopts",
          "syntax",
          "filetype",
          "illuminate",
          "treesitter",
          "lsp",
        }
      }
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require('project_nvim').setup {}
      require('telescope').load_extension('projects')

      local keyset = vim.keymap.set
      keyset("n", "<leader>fp", "<CMD>lua require('telescope').extensions.projects.projects{}<CR>", { silent = true })
    end
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    config = function()
      require("persistence").setup {}
      -- restore the session for the current directory
      vim.api.nvim_set_keymap("n", "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], {})

      -- restore the last session
      vim.api.nvim_set_keymap("n", "<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

      -- stop Persistence => session won't be saved on exit
      vim.api.nvim_set_keymap("n", "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], {})
    end,
  }
}
