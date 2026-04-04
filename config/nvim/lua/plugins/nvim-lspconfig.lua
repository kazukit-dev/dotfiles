---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable({
        "cssls",
        "html",
        "jsonls",
        "lua_ls",
        "nixd",
        "oxlint",
        "sqls",
        "ts_ls",
        "typos_lsp",
        "yamlls",
      })
    end,
  },
}
