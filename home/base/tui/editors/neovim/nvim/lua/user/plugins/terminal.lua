return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        autochdir = false,
        persist_mode = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
        },
        terminal_mappings = true,
      }

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        local keyset = vim.keymap.set

        keyset('t', '<ESC>', [[ <C-\><C-n> ]], opts)
        keyset('t', 'jj', [[ <C-\><C-n> ]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },
}
