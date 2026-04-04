---@type LazySpec
return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    build = ":KanagawaCompile",
    config = function()
      require("kanagawa").setup({
        compile = true,
        transparent = true,
        globalStatus = true,
        overrides = function(colors)
          local theme = colors.theme
          return {
            StatusLine = { link = "Normal" },
            StatusLineNC = { link = "Normal" },
            NoiceVirtualText = { bg = theme.ui.bg_search },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
}
