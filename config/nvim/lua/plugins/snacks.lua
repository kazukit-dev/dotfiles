---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      styles = {
        float = {
          border = "rounded",
        },
      },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = "󰈔 ", key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              icon = "󰒍 ",
              key = "d",
              desc = "Dotfiles",
              action = ":lua Snacks.dashboard.pick('files', {cwd = '~/dotfiles'})",
            },
            { icon = "󰐥 ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header", padding = 1 },
          { icon = "󰈙 ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = "󰏋 ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { icon = "⌨ ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        },
      },
      lazygit = {
        enabled = true,
        win = {
          style = "lazygit",
          wo = {
            winhighlight = "NormalFloat:Normal",
          },
        },
      },
      rename = { enabled = true },
      statuscolumn = { enabled = true },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Git Files",
      },
      {
        "<leader>rf",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      {
        "<leader>ll",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log",
      },
      {
        "<leader>lf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Log (current file)",
      },
    },
  },
}
