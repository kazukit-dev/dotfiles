---@type LazySpec
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", mode = "n", desc = "Stage hunk" },
      { "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", mode = "n", desc = "Preview hunk" },
      { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", mode = "n", desc = "Reset hunk" },
      { "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>", mode = "n", desc = "Undo stage hunk" },
    },
    opts = {},
  },
}
