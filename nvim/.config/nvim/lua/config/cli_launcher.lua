-- CLI launcher for running files and installing packages from Neovim.
-- It detects local Python virtual environments and local Node tools.

local M = {}

local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local sep = is_windows and "\\" or "/"

-- Find executable in virtual environment or node_modules
local function find_executable(cmd, search_paths)
    local cwd = vim.fn.getcwd()
    for _, path in ipairs(search_paths) do
        -- Check if the path exists before checking for executables
        local full_path = cwd .. sep .. path
        if vim.fn.isdirectory(full_path) == 1 then
            local bin_dir = is_windows and (sep .. "Scripts" .. sep) or (sep .. "bin" .. sep)
            local exe = full_path .. bin_dir .. cmd
            if is_windows then
                exe = exe .. ".exe"
            end
            if vim.fn.executable(exe) == 1 then
                return exe
            end
        end
    end
    return cmd
end

-- Run commands for each language
local run_commands = {
    python = function(file)
        return find_executable("python", { "venv", ".venv", "env", ".env" }) .. ' "' .. file .. '"'
    end,
    javascript = function(file)
        return find_executable("node", { "node_modules/.bin" }) .. ' "' .. file .. '"'
    end,
    typescript = function(file)
        local tsx = find_executable("tsx", { "node_modules/.bin" })
        return (vim.fn.executable(tsx) == 1 and tsx or "npx tsx") .. ' "' .. file .. '"'
    end,
    rust = function()
        return "cargo run"
    end,
    go = function(file)
        return 'go run "' .. file .. '"'
    end,
    c = function(file)
        local out = file:gsub("%.c$", "")
        local run = is_windows and ('"' .. out .. '.exe"') or ("./" .. out)
        return 'gcc "' .. file .. '" -o "' .. out .. '" && ' .. run
    end,
    cpp = function(file)
        local out = file:gsub("%.cpp$", "")
        local run = is_windows and ('"' .. out .. '.exe"') or ("./" .. out)
        return 'g++ "' .. file .. '" -o "' .. out .. '" && ' .. run
    end,
    lua = function(file)
        return 'lua "' .. file .. '"'
    end,
    sh = function(file)
        return 'bash "' .. file .. '"'
    end,
    bash = function(file)
        return 'bash "' .. file .. '"'
    end,
}

-- Install commands for each language
local install_commands = {
    python = function(pkg)
        return find_executable("pip", { "venv", ".venv", "env", ".env" }) .. " install " .. pkg
    end,
    javascript = function(pkg)
        return "npm install " .. pkg
    end,
    typescript = function(pkg)
        return "npm install " .. pkg
    end,
    rust = function(pkg)
        return "cargo add " .. pkg
    end,
    go = function(pkg)
        return "go get " .. pkg
    end,
}

function M.setup()
    -- Run current file (Space + r)
    vim.keymap.set("n", "<leader>r", function()
        local ft = vim.bo.filetype
        local file = vim.fn.expand("%:p") -- Full path to avoid directory issues
        local filename = vim.fn.expand("%:t") -- Just filename for display
        local run_fn = run_commands[ft]

        if not run_fn then
            vim.notify("No run command for filetype: " .. ft, vim.log.levels.WARN)
            return
        end

        local cmd = run_fn(file)

        vim.ui.input({
            prompt = "Run (" .. filename .. "): ",
            default = cmd,
        }, function(user_cmd)
            if user_cmd and user_cmd ~= "" then
                -- Open terminal in current file's directory
                local file_dir = vim.fn.expand("%:p:h")
                vim.cmd("split")
                vim.cmd("lcd " .. vim.fn.fnameescape(file_dir))
                vim.cmd("terminal " .. user_cmd)
                vim.cmd("startinsert") -- Enter insert mode in terminal
            end
        end)
    end, { desc = "Run file" })

    -- Install package (Space + i)
    vim.keymap.set("n", "<leader>i", function()
        local ft = vim.bo.filetype
        local install_fn = install_commands[ft]

        if not install_fn then
            vim.notify("No install command for filetype: " .. ft, vim.log.levels.WARN)
            return
        end

        vim.ui.input({ prompt = "Package: " }, function(pkg)
            if pkg and pkg ~= "" then
                local file_dir = vim.fn.expand("%:p:h")
                vim.cmd("split")
                vim.cmd("lcd " .. vim.fn.fnameescape(file_dir))
                vim.cmd("terminal " .. install_fn(pkg))
                vim.cmd("startinsert")
            end
        end)
    end, { desc = "Install package" })
end

return M
