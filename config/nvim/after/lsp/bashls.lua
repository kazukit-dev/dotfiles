---@type vim.lsp.Config
return {
  -- zsh is excluded: shellcheck (run by bash-language-server) does not
  -- support zsh and reports false positives on valid zsh syntax.
  filetypes = { "sh", "bash" },
  settings = {
    bashIde = {
      shellcheckPath = "shellcheck",
    },
  },
}
