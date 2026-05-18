local M = {}

local function join(...)
    return table.concat({ ... }, "/")
end

function M.is_executable(path)
    return path and path ~= "" and vim.fn.executable(path) == 1
end

function M.first_executable(paths)
    for _, path in ipairs(paths) do
        if M.is_executable(path) then
            return path
        end
    end
end

local function is_inside(path, root_dir)
    local normalized_path = vim.fs.normalize(path)
    local normalized_root = vim.fs.normalize(root_dir):gsub("/$", "")
    return normalized_path == normalized_root or normalized_path:sub(1, #normalized_root + 1) == normalized_root .. "/"
end

function M.python(root_dir)
    for _, name in ipairs({ ".venv", "venv", "env", ".env" }) do
        local python = M.first_executable({
            join(root_dir, name, "bin", "python"),
            join(root_dir, name, "Scripts", "python.exe"),
        })
        if python then
            return python
        end
    end

    local venv = os.getenv("VIRTUAL_ENV")
    if venv and is_inside(venv, root_dir) then
        local python = M.first_executable({
            join(venv, "bin", "python"),
            join(venv, "Scripts", "python.exe"),
        })
        if python then
            return python
        end
    end

    local python3 = vim.fn.exepath("python3")
    if python3 ~= "" then
        return python3
    end

    local python = vim.fn.exepath("python")
    return python ~= "" and python or "python"
end

function M.node_bin(root_dir, executable)
    local local_bin = M.first_executable({
        join(root_dir, "node_modules", ".bin", executable),
        join(root_dir, "node_modules", ".bin", executable .. ".cmd"),
    })
    if local_bin then
        return local_bin
    end

    local global_bin = vim.fn.exepath(executable)
    return global_bin ~= "" and global_bin or nil
end

function M.typescript_sdk(root_dir)
    local local_sdk = join(root_dir, "node_modules", "typescript", "lib")
    if vim.fn.isdirectory(local_sdk) == 1 then
        return local_sdk
    end
end

return M
