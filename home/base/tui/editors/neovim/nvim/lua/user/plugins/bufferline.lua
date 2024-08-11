local M =
{
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = "BufReadPre",
}

M.config = function()
  vim.opt.termguicolors = true
  require('bufferline').setup {
    options = {
      diagnostics = "nvim_lsp",
      -- separator_style = "slant",
      always_show_bufferline = true,
      color_icons = true,

      buffer_close_icon = "",
      close_command = "bdelete %d",
      close_icon = "",
      indicator = {
        style = "icon",
        icon = " ",
      },
      left_trunc_marker = "",
      modified_icon = "●",
      offsets = {
        {
          filetype = "NvimTree",
          text = function()
            return "EXPLORER"
          end,
          highlight = "Directory",
          text_align = "left",
        }
      },
      right_mouse_command = "bdelete! %d",
      right_trunc_marker = "",
      show_close_icon = false,
      show_tab_indicators = true,
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
    },
    highlights = {
      -- fill = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "StatusLineNC" },
      -- },
      -- background = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "StatusLine" },
      -- },
      -- buffer_visible = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "Normal" },
      -- },
      -- buffer_selected = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "Normal" },
      -- },
      -- separator = {
      --   fg = { attribute = "bg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "StatusLine" },
      -- },
      -- separator_selected = {
      --   fg = { attribute = "fg", highlight = "Special" },
      --   bg = { attribute = "bg", highlight = "Normal" },
      -- },
      -- separator_visible = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "StatusLineNC" },
      -- },
      -- close_button = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "StatusLine" },
      -- },
      -- close_button_selected = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "Normal" },
      -- },
      -- close_button_visible = {
      --   fg = { attribute = "fg", highlight = "Normal" },
      --   bg = { attribute = "bg", highlight = "Normal" },
      -- },
    },
  }
  -- since we open empty splits - clean them up as we cycle through open buffers
  function ChangeTab(motion)
    local last_buffer_id = vim.fn.bufnr()
    local last_buffer_name = vim.fn.expand("%")

    if motion == "next" then
      vim.cmd([[BufferLineCycleNext]])
    elseif motion == "prev" then
      vim.cmd([[BufferLineCyclePrev]])
    else
      error("Invalid motion: " .. motion)
      return
    end

    if last_buffer_name == "" then
      vim.cmd("bd " .. last_buffer_id)
    end
  end

  local keyset = vim.keymap.set

  -- switch through visible buffers with shift-l/h
  keyset("n", "<S-l>", "<CMD>lua ChangeTab('next')<CR>", {})
  keyset("n", "<S-h>", "<CMD>lua ChangeTab('prev')<CR>", {})

  -- switch through pressing <leader><ordinal>
  for i = 1, 9 do
    keyset("n", "<leader>" .. i, "<CMD> lua require(\"bufferline\").go_to_buffer(" .. i .. ", true)<CR>",
      { silent = true })
  end
end

return M
