---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.enable({
        "cssls",
        "dockerls",
        "eslint",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "nixd",
        "oxlint",
        "sqls",
        "ts_ls",
        "typos_lsp",
        "vue_ls",
        "yamlls",
        "bashls",
      })
    end,
  },
}
