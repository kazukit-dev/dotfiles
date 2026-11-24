---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      require("nvim-treesitter").install({
        "lua",
        "nix",
        "typescript",
        "tsx",
        "javascript",
        "vue",
        "html",
        "json",
        "rust",
        "yaml",
        "toml",
        "bash",
        "markdown",
        "markdown_inline",
        "vim",
        "vimdoc",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start)

          -- Do not set indentexpr unconditionally. Without an indents query it returns 0
          -- (or -1 without a parser), overriding autoindent and the filetype's indent script.
          local lang = vim.treesitter.language.get_lang(args.match)
          local ok, indents = pcall(vim.treesitter.query.get, lang, "indents")
          if ok and indents then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
