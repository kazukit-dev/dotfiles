---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      -- Run clippy instead of `cargo check` on save
      check = { command = "clippy" },
    },
  },
}
