vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.scrolloff = 8
opt.updatetime = 250

vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s)", diagnostic.message, diagnostic.source or "Unknown")
    end,
  },
  signs = true,
  underline = true,
  float = { border = "rounded" },
})
