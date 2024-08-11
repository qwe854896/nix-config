local lazypath = vim.fn.stdpath("data") ..
    "/lazy/lazy.nvim"                  -- Set the lazypath variable to the path of the lazy.nvim plugin
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then -- Check if the lazypath file exists
  vim.fn.system({                      -- Clone the lazy.nvim repository if the file doesn't exist
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Clone the latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath) -- Prepend the lazypath to the runtimepath option

vim.opt.updatetime = 300 -- Set the updatetime option to 300 milliseconds

vim.g.mapleader = " "       -- Set the mapleader to a space character
vim.g.maplocalleader = "\\" -- Set the maplocalleader to a backslash character

require('lazy').setup('user.plugins')
require('user.keymaps')
require('user.indent')

vim.opt.shell = "fish"

