return {
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = { "node_modules/", ".git/" },
          prompt_prefix = "🔍 ",
          selection_caret = "❯ ",
          layout_config = {
            prompt_position = "top",
            horizontal = {
              width_padding = 0.1,
              height_padding = 0.1,
              preview_width = 0.6,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
            },
          },
          mappings = {
            i = {
              ["<esc>"] = require('telescope.actions').close,
            },
          },
          preview = {
            treesitter = false,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }

      local keyset = vim.keymap.set
      keyset("n", "<leader>ff", "<CMD>lua require('telescope.builtin').find_files()<CR>", { silent = true })
      keyset("n", "<leader>fg", "<CMD>lua require('telescope.builtin').live_grep()<CR>", { silent = true })
      keyset("n", "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>", { silent = true })
      keyset("n", "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>", { silent = true })
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
}
