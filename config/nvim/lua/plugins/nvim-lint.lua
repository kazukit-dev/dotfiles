---@type LazySpec
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
      }

      local function lint_buffer()
        lint.try_lint(nil, { ignore_errors = true })

        -- GitHub Actions workflow files have plain "yaml" filetype,
        -- so trigger actionlint by path instead of filetype
        if vim.api.nvim_buf_get_name(0):match("%.github/workflows/") then
          lint.try_lint("actionlint")
        end
      end

      -- FileType (not BufReadPost) so linters resolve after filetype detection
      vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = lint_buffer,
      })

      -- The event that lazy-loaded this plugin has already fired for the
      -- current buffer, so lint it once after filetype detection settles
      vim.schedule(lint_buffer)
    end,
  },
}
