return {
  {
    "RRethy/vim-illuminate",
    config = function()
      require('illuminate').configure(
        {
          filetypes_denylist = {
            'dirbuf',
            'dirvish',
            'fugitive',
            'NvimTree',
            'toggleterm',
          }
        }
      )
    end,
  },
  "windwp/nvim-ts-autotag",
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
  -- "HiPhish/rainbow-delimiters.nvim",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup {}
    end,
  },
  {
    "sitiom/nvim-numbertoggle",
    config = function()
      vim.opt.number = true
      vim.opt.relativenumber = true
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        '*',
      }
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup {}
      require('cmp').event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
      )
    end,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    'numToStr/Comment.nvim',
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require('Comment').setup {
        -- pre_hook = function()
        --   return vim.bo.commentstring
        -- end,
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    -- This plugin is considered to be removed in the future
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitute_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    config = function()
      require("guess-indent").setup {
        auto_cmd = true,
      }
    end,
  }
}
