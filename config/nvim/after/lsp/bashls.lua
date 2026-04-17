---@type vim.lsp.Config
return {
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      shellcheckPath = "shellcheck",
    },
  },
}
