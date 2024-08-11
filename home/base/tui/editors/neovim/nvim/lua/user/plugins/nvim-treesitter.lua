return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup {
        ensure_installed = {
          "javascript",
          "html",
          "css",
        },
        auto_install = true,
        sync_install = false,
        highlight = {
          enable = true,
          disable = function()
            -- check if 'filetype' option includes 'chezmoitmpl'
            if string.find(vim.bo.filetype, 'chezmoitmpl') then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },
      }

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end
  },
}
