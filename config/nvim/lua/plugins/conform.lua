-- Use oxfmt when the project provides it, otherwise fall back to prettier.
-- Both resolve from the project's node_modules/.bin, so nothing runs in
-- projects that install neither.
local prettier_like = { "oxfmt", "prettier", stop_after_first = true }

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        nix = { "nixfmt" },
        javascript = prettier_like,
        javascriptreact = prettier_like,
        typescript = prettier_like,
        typescriptreact = prettier_like,
        vue = prettier_like,
        json = prettier_like,
        jsonc = prettier_like,
        css = prettier_like,
        scss = prettier_like,
        html = prettier_like,
        markdown = prettier_like,
        yaml = prettier_like,
        graphql = prettier_like,
      },
      -- Fall back to LSP formatting when no formatter is configured/available
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 1000 },
    },
  },
}
