vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- use 2 spaces for indentation
    vim.bo.tabstop = 2             -- default: 8; VIEW
    vim.bo.softtabstop = 2         -- default: 0; EDIT
    vim.bo.shiftwidth = 2          -- default: 8; SHIFT
    vim.bo.autoindent = true       -- default: true; Copy indent from current line
    vim.opt_local.smarttab = true  -- default: true; Use shiftwidth when editing
    vim.opt_local.expandtab = true -- default: false; Use spaces instead of tabs
  end,
})
