return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  priority = 1000,
  opts = {
    transparent = true,
    theme = "dragon",
  },
  config = function()
    vim.cmd([[colorscheme kanagawa-dragon]])
  end,
}
