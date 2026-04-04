---@type LazySpec
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      { "hs", "<cmd>Gitsigns stage_hunk<cr>", mode = "n" },
      { "hp", "<cmd>Gitsigns preview_hunk<cr>", mode = "n" },
      { "hr", "<cmd>Gitsigns reset_hunk<cr>", mode = "n" },
      { "hu", "<cmd>Gitsigns undo_stage_hunk<cr>", mode = "n" },
    },
    opts = {},
  },
}
