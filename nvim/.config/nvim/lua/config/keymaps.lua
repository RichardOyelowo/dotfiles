-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic keymaps
map("i", "jj", "<ESC>")
map("n", "U", "<C-r>", { desc = "Redo" })
map({ "n", "v" }, "<leader>q", "<cmd>q!<CR>", { desc = "Quit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })
map("n", "<Esc>", "<CMD>nohlsearch<CR>", { desc = "Clear search" })

-- FIle & window keymaps
map({ "n", "v" }, "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>c", "<cmd>%y+<CR>", { desc = "Copy file contents" })
map({ "n", "v" }, "<leader>h", "<cmd>split<CR>", { desc = "h split" })
map({ "n", "v" }, "<leader>v", "<cmd>vsplit<CR>", { desc = "v split" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- Tab, shift-Tab: indent/unindent selection or current line
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("n", "<Tab>", ">>", opts)
map("n", "<S-Tab>", "<<", opts)

-- Markdown configuration
map("n", "<leader>mb", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "Toggle Markdown (buffer)" })
map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-- format file content
map({ "n", "x" }, "<leader>fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "<leader>r", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "Incremental Rename" })

-- refactoring
map({ "n", "x" }, "<leader>Rs", function()
    require("refactoring").select_refactor()
end, { desc = "Select Refactor" })

map({ "n", "x" }, "<leader>Re", function()
    return require("refactoring").extract_func()
end, { expr = true, desc = "Extract Function" })

map({ "n", "x" }, "<leader>RF", function()
    return require("refactoring").extract_func_to_file()
end, { expr = true, desc = "Extract Function To File" })

map({ "n", "x" }, "<leader>Rv", function()
    return require("refactoring").extract_var()
end, { expr = true, desc = "Extract Variable" })

map({ "n", "x" }, "<leader>Ri", function()
    return require("refactoring").inline_var()
end, { expr = true, desc = "Inline Variable" })

map({ "n", "x" }, "<leader>RI", function()
    return require("refactoring").inline_func()
end, { expr = true, desc = "Inline Function" })

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
map("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next Todo Comment" })

map("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous Todo Comment" })

map("n", "<leader>xt", "<cmd>Trouble todo toggle<CR>", { desc = "Todo (Trouble)" })
map("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<CR>", {
    desc = "Todo/Fix/Fixme (Trouble)",
})

map("n", "<leader>st", function()
    Snacks.picker.todo_comments()
end, { desc = "Todo" })

map("n", "<leader>sT", function()
    Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })
