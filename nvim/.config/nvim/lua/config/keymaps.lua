---------------------------------------------------------------------
-- KEYMAP PHILOSOPHY
--
-- This file serves as both my keybindings and my Neovim cheat sheet.
--
-- Only add mappings that:
--   • improve discoverability
--   • save frequent actions
--   • expose useful plugin features
--   • are difficult to remember
--
-- Prefer LazyVim defaults unless a custom mapping provides
-- a clear improvement.
---------------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap = true, silent = true }


-- Basic keymaps
map("i", "jj", "<ESC>")
map("n", "U", "<C-r>", { desc = "Redo" })
map({ "n", "v" }, "<leader>qq", "<cmd>q!<CR>", { desc = "Force quit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })
map("n", "<Esc>", "<CMD>nohlsearch<CR>", { desc = "Clear search" })

map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("n", "<Tab>", ">>", opts)
map("n", "<S-Tab>", "<<", opts)


-- FIle & window keymaps
map({ "n", "v" }, "<leader>ww", "<cmd>w<CR>", { desc = "Save file" })
map({ "n", "v" }, "<leader>y", "<cmd>%y+<CR>", { desc = "Copy file contents" })
map({ "n", "v" }, "<leader>c", ":y<CR>", { desc = "Copy highlighted text" })
map({ "n", "v" }, "<leader>h", "<cmd>split<CR>", { desc = "h split" })
map({ "n", "v" }, "<leader>v", "<cmd>vsplit<CR>", { desc = "v split" })
map("n", "<leader>N", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>R", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map({ "n", "x" }, "<leader>fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })


-- Navigation & Search
map("n", "<leader>,", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Explorer" })

map("n", "<leader>sg", function()
  Snacks.picker.git_files()
end, { desc = "Git Files" })

map("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Help Tags" })

map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })

map("n", "<leader>ss", function()
  Snacks.picker.resume()
end, { desc = "Resume Search" })

map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("n", "<Tab>", ">>", opts)
map("n", "<S-Tab>", "<<", opts)


-- global lsp mappings
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<leader>cr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Rename Symbol" })
map("n", "<leader>cr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Incremental Rename" })

    
-- refactoring
map({ "n", "x" }, "<leader>Rs", function()
    require("refactoring").select_refactor()
end, { desc = "Select Refactor" })


-- cli launcher  for code running & Package installations
map("n", "<leader>rr", function()
    require("config.cli_launcher").run_file()
end, { desc = "Run file" })

map("n", "<leader>ri", function()
    require("config.cli_launcher").install_package()
end, { desc = "Install package" })


-- Flash
map({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash Jump" })

map({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter" })


-- Git
map("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Prev Hunk" })

map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame Line" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })


-- Diagnostics
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<CR>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List" })


-- Markdown configuration
map("n", "<leader>mb", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "Toggle Markdown (buffer)" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })


-- REST requests
map("n", "<leader>ar", "<cmd>Rest run<CR>", { desc = "Run REST Request" })
map("n", "<leader>al", "<cmd>Rest last<CR>", { desc = "Run Last REST Request" })
map("n", "<leader>ao", "<cmd>Rest open<CR>", { desc = "Open REST Result" })
map("n", "<leader>ae", "<cmd>Rest env select<CR>", { desc = "Select REST Env" })
map("n", "<leader>ac", "<cmd>Rest cookies<CR>", { desc = "Open REST Cookies" })
map("n", "<leader>ag", "<cmd>Rest logs<CR>", { desc = "Open REST Logs" })


-- debugging
map("n", "<leader>db", function()
    require("dap").toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

map("n", "<leader>dB", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Conditional Breakpoint" })

map("n", "<leader>dc", function()
    require("dap").continue()
end, { desc = "Debug Continue" })

map("n", "<leader>di", function()
    require("dap").step_into()
end, { desc = "Step Into" })

map("n", "<leader>do", function()
    require("dap").step_over()
end, { desc = "Step Over" })

map("n", "<leader>dO", function()
    require("dap").step_out()
end, { desc = "Step Out" })

map("n", "<leader>dr", function()
    require("dap").repl.toggle()
end, { desc = "Debug REPL" })

map("n", "<leader>dt", function()
    require("dap").terminate()
end, { desc = "Debug Terminate" })


-- todo-comments
map("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>", { desc = "Todo (Trouble)" })
map("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>", {
    desc = "Todo/Fix/Fixme (Trouble)",
})

map("n", "<leader>st", function()
    Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })

map("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })

map("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous Todo Comment" })


map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

