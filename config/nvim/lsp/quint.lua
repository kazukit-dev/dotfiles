---@type vim.lsp.Config
return {
  cmd = { "quint-language-server", "--stdio" },
  filetypes = { "quint" },
  root_markers = { ".git" },
}
