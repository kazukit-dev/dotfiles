---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
      vim.lsp.enable({
        "cssls",
        "dockerls",
        "efm",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "nixd",
        "oxlint",
        "sqls",
        "ts_ls",
        "typos_lsp",
        "yamlls",
        "bashls",
      })
    end,
  },
}
