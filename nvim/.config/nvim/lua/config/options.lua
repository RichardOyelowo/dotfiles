-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.loaded_perl_provider = 0

vim.opt.pumheight = 10
vim.opt.confirm = true
vim.opt.showmode = false
vim.opt.conceallevel = 0
vim.opt.grepprg = "rg --vimgrep"

vim.opt.number = true
vim.opt.ruler = false
vim.opt.numberwidth = 4
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.wrap = false

vim.opt.clipboard = "unnamedplus"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.completeopt = "menuone,noselect"

vim.opt.breakindent = true

vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.backup = false
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.cmdheight = 1
vim.opt.signcolumn = "yes:1"
vim.opt.statuscolumn = ""

vim.opt.list = false
