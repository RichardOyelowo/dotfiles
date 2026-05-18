vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.diagnostics").setup()
require("config.lazy")
require("config.cli_launcher").setup()
