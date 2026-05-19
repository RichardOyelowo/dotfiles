vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.diagnostics").setup()
require("config.cli_launcher").setup()
require("config.filetypes")
require("config.lazy")
