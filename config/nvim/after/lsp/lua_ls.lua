---@type vim.lsp.Config
return {
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
        },
      },
      format = { enable = false },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
}
