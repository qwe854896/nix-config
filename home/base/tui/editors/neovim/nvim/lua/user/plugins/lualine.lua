local M = {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}

local function mixed_indent()
  local space_pat = [[\v^ +]]
  local tab_pat = [[\v^\t+]]
  local space_indent = vim.fn.search(space_pat, 'nwc')
  local tab_indent = vim.fn.search(tab_pat, 'nwc')
  local mixed = (space_indent > 0 and tab_indent > 0)
  local mixed_same_line

  if not mixed then
    mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
    mixed = mixed_same_line > 0
  end

  -- Return "Tab" or "Spaces: <count>"
  if not mixed then
    if tab_indent > 0 then
      return 'Tab'
    else
      return 'Spaces: ' .. vim.opt.tabstop:get()
    end
  end

  if mixed_same_line ~= nil and mixed_same_line > 0 then
    return 'MI:' .. mixed_same_line
  end

  local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
  local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total

  if space_indent_cnt > tab_indent_cnt then
    return 'MI:' .. tab_indent
  else
    return 'MI:' .. space_indent
  end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end

local copilot_indicator = function()
  local client = vim.lsp.get_clients({ name = "copilot" })[1]
  if client == nil then
    return ""
  end

  if vim.tbl_isempty(client.requests) then
    return "" -- default icon for copilot
  end

  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

  ---@diagnostic disable-next-line: undefined-field
  local frame = math.floor(vim.loop.hrtime() / 1000000 / 120) % #spinners

  return spinners[frame]
end

local function lsp_info_status()
  local clients = vim.lsp.get_clients()
  if vim.tbl_isempty(clients) then
    return ""
  end

  local lsp_name = ""
  for _, client in ipairs(clients) do
    ---@diagnostic disable-next-line: undefined-field
    for _, filetype in ipairs(client.config.filetypes) do
      if vim.bo.filetype == filetype then
        lsp_name = client.name
        return lsp_name
      end
    end
  end
  return ""
end


M.config = function()
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'tokyonight',
      -- theme = 'vscode',
      section_separators = '',
      component_separators = '',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        'diff',
        'diagnostics',
      },
      lualine_c = {
        -- { 'filename', },
        -- { require("nvim-treesitter").statusline, fmt = trunc(90, 30, 50, false) },
      },
      lualine_x = {
        { mixed_indent },
        'encoding',
        {
          'fileformat',
          icons_enabled = true,
          symbols = {
            unix = ' LF',
            dos = ' CRLF',
            mac = ' CR',
          },
        },
        'filetype',
        { lsp_info_status },
        { copilot_indicator },
      },
      lualine_y = {
        { window },
        'progress',
      },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { 'fugitive', 'toggleterm', 'nvim-tree' },
  }
end

return M
