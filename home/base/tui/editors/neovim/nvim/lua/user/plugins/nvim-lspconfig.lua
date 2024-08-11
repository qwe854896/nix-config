local M = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
}

M.config = function()
  -- Always show the signcolumn, otherwise it would shift the text each time
  -- diagnostics appeared/became resolved
  vim.opt.signcolumn = "yes"

  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Setup servers
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_init = function(client)
      local path = client.workspace_folders[1].name
      ---@diagnostic disable-next-line: undefined-field
      if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT'
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library",
            -- "${3rd}/busted/library",
          }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }

  lspconfig.clangd.setup {
    capabilities = capabilities,
    cmd = {
      "clangd",
      "--offset-encoding=utf-16",
    },
  }

  lspconfig.pyright.setup {
    capabilities = capabilities,
  }

  lspconfig.yamlls.setup {
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ['http://json.schemastore.org/github-workflow.json'] = "/.github/workflows/*",
        }
      }
    }
  }

  lspconfig.marksman.setup {
    capabilities = capabilities,
  }

  -- Global mappings
  local keyset = vim.keymap.set

  keyset('n', '<leader>e', vim.diagnostic.open_float)
  keyset('n', '[d', vim.diagnostic.goto_prev)
  keyset('n', ']d', vim.diagnostic.goto_next)
  keyset('n', '<leader>q', vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      keyset('n', 'gD', vim.lsp.buf.declaration, opts)
      keyset('n', 'gd', vim.lsp.buf.definition, opts)
      keyset('n', 'K', vim.lsp.buf.hover, opts)
      keyset('n', 'gi', vim.lsp.buf.implementation, opts)
      keyset('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      keyset('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      keyset('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      keyset('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      keyset('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      keyset('n', '<leader>rn', vim.lsp.buf.rename, opts)
      keyset({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      keyset('n', 'gr', vim.lsp.buf.references, opts)
      keyset({ 'n', 'x' }, '<leader>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end,
  })
end

return M
