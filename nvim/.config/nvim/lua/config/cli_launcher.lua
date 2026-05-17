-- CLI launcher for running files and installing packages from Neovim.
-- It detects local Python virtual environments and local Node tools.

local M = {}

local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local sep = is_windows and "\\" or "/"

local function join_path(...)
    return table.concat({ ... }, sep)
end

local function is_executable(path)
    return vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1
end

local function shell(path)
    return vim.fn.shellescape(path)
end

-- Find executable in virtual environments, project bin folders, or PATH.
local function find_executable(cmd, search_paths)
    local cwd = vim.fn.getcwd()
    for _, path in ipairs(search_paths) do
        local full_path = join_path(cwd, path)
        if vim.fn.isdirectory(full_path) == 1 then
            local candidates = {
                join_path(full_path, cmd),
                join_path(full_path, is_windows and "Scripts" or "bin", cmd),
            }

            if is_windows then
                vim.list_extend(candidates, {
                    join_path(full_path, cmd .. ".exe"),
                    join_path(full_path, "Scripts", cmd .. ".exe"),
                })
            end

            for _, exe in ipairs(candidates) do
                if is_executable(exe) then
                    return shell(exe)
                end
            end
        end
    end

    if vim.fn.executable(cmd) == 1 then
        return cmd
    end

    return nil
end

local function missing_executable(cmd)
    vim.notify("Missing executable: " .. cmd, vim.log.levels.ERROR)
    return nil
end

-- Run commands for each language
local run_commands = {
    python = function(file)
        local python = find_executable("python", { "venv", ".venv", "env", ".env" })
        return python and (python .. " " .. shell(file)) or missing_executable("python")
    end,
    javascript = function(file)
        local node = find_executable("node", {})
        return node and (node .. " " .. shell(file)) or missing_executable("node")
    end,
    typescript = function(file)
        local tsx = find_executable("tsx", { "node_modules/.bin" })
        if tsx then
            return tsx .. " " .. shell(file)
        end

        local npx = find_executable("npx", {})
        return npx and (npx .. " tsx " .. shell(file)) or missing_executable("tsx or npx")
    end,
    rust = function()
        return find_executable("cargo", {}) and "cargo run" or missing_executable("cargo")
    end,
    go = function(file)
        local go = find_executable("go", {})
        return go and (go .. " run " .. shell(file)) or missing_executable("go")
    end,
    c = function(file)
        local gcc = find_executable("gcc", {})
        if not gcc then
            return missing_executable("gcc")
        end

        local out = vim.fn.fnamemodify(file, ":t:r")
        local run = is_windows and shell(out .. ".exe") or ("./" .. shell(out))
        return gcc .. " " .. shell(file) .. " -o " .. shell(out) .. " && " .. run
    end,
    cpp = function(file)
        local gpp = find_executable("g++", {})
        if not gpp then
            return missing_executable("g++")
        end

        local out = vim.fn.fnamemodify(file, ":t:r")
        local run = is_windows and shell(out .. ".exe") or ("./" .. shell(out))
        return gpp .. " " .. shell(file) .. " -o " .. shell(out) .. " && " .. run
    end,
    lua = function(file)
        local lua = find_executable("lua", {})
        return lua and (lua .. " " .. shell(file)) or missing_executable("lua")
    end,
    sh = function(file)
        local bash = find_executable("bash", {})
        return bash and (bash .. " " .. shell(file)) or missing_executable("bash")
    end,
    bash = function(file)
        local bash = find_executable("bash", {})
        return bash and (bash .. " " .. shell(file)) or missing_executable("bash")
    end,
}

-- Install commands for each language
local install_commands = {
    python = function(pkg)
        local pip = find_executable("pip", { "venv", ".venv", "env", ".env" })
        return pip and (pip .. " install " .. shell(pkg)) or missing_executable("pip")
    end,
    javascript = function(pkg)
        local npm = find_executable("npm", {})
        return npm and (npm .. " install " .. shell(pkg)) or missing_executable("npm")
    end,
    typescript = function(pkg)
        local npm = find_executable("npm", {})
        return npm and (npm .. " install " .. shell(pkg)) or missing_executable("npm")
    end,
    rust = function(pkg)
        local cargo = find_executable("cargo", {})
        return cargo and (cargo .. " add " .. shell(pkg)) or missing_executable("cargo")
    end,
    go = function(pkg)
        local go = find_executable("go", {})
        return go and (go .. " get " .. shell(pkg)) or missing_executable("go")
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
        if not cmd then
            return
        end

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
                local cmd = install_fn(pkg)
                if not cmd then
                    return
                end

                local file_dir = vim.fn.expand("%:p:h")
                vim.cmd("split")
                vim.cmd("lcd " .. vim.fn.fnameescape(file_dir))
                vim.cmd("terminal " .. cmd)
                vim.cmd("startinsert")
            end
        end)
    end, { desc = "Install package" })
end

return M
