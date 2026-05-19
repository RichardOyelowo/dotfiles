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

local function python_from_venv(path)
    return M.first_executable({
        join(path, "bin", "python"),
        join(path, "Scripts", "python.exe"),
    })
end

function M.python_env(root_dir)
    for _, name in ipairs({ ".venv", "venv", "env", ".env" }) do
        local path = join(root_dir, name)
        local python = python_from_venv(path)
        if python then
            return {
                python = python,
                venv = name,
                venv_path = root_dir,
            }
        end
    end

    local venv = os.getenv("VIRTUAL_ENV")
    if venv and is_inside(venv, root_dir) then
        local python = python_from_venv(venv)
        if python then
            return {
                python = python,
                venv = vim.fn.fnamemodify(venv, ":t"),
                venv_path = vim.fn.fnamemodify(venv, ":h"),
            }
        end
    end

    local python3 = vim.fn.exepath("python3")
    if python3 ~= "" then
        return { python = python3 }
    end

    local python = vim.fn.exepath("python")
    return { python = python ~= "" and python or "python" }
end

function M.python(root_dir)
    return M.python_env(root_dir).python
end

function M.python_venv(root_dir)
    local env = M.python_env(root_dir)
    return env.venv_path, env.venv
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
