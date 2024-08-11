return {
  {
    "tpope/vim-fugitive",
    event = "BufWinEnter",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {}
    end
  },
}
