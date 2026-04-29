---@type vim.lsp.Config
return {
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", pathStrict = true, path = { "?.lua", "?/init.lua" } },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
          vim.fn.stdpath("data") .. "/lazy/snacks.nvim",
          vim.fn.stdpath("data") .. "/lazy/mini.statusline",
        },
      },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
}
