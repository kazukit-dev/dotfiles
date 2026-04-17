local stylua = {
  formatCommand = "stylua --stdin-filepath ${INPUT} -",
  formatStdin = true,
}

local nixfmt = {
  formatCommand = "nixfmt",
  formatStdin = true,
}

local actionlint = {
  lintCommand = "actionlint -stdin-filename ${INPUT} -",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".github/" },
}

local hadolint = {
  lintCommand = "hadolint --no-color -",
  lintStdin = true,
  lintFormats = { "-:%l %.%# %trror: %m", "-:%l %.%# %tarning: %m", "-:%l %.%# %tnfo: %m" },
}

---@type vim.lsp.Config
return {
  init_options = {
    documentFormatting = true,
  },
  filetypes = { "lua", "nix", "yaml.github", "dockerfile" },
  settings = {
    languages = {
      lua = { stylua },
      nix = { nixfmt },
      ["yaml.github"] = { actionlint },
      dockerfile = { hadolint },
    },
  },
}
