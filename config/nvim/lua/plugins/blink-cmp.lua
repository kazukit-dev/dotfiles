---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      -- <CR> to accept, <C-n>/<C-p> to select, <C-b>/<C-f> to scroll docs,
      -- <C-space> to show completion / toggle docs
      keymap = { preset = "enter" },
      completion = {
        -- Do not preselect; <CR> confirms only an explicitly selected item
        list = { selection = { preselect = false, auto_insert = true } },
        documentation = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
    },
  },
}
