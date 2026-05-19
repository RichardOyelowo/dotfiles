local M = {}

local ignore_patterns = {
    "nvim%-diagnostic%-ignore",
    "#%s*ignore",
    "//%s*ignore",
    "%-%-%s*ignore",
    "/%*%s*ignore%s*%*/",
    "<!%-%-%s*ignore%s*%-%->",
}

local function line_has_ignore_marker(bufnr, lnum)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum, lnum + 1, false)
    if not ok or not lines[1] then
        return false
    end

    local line = lines[1]:lower()
    for _, pattern in ipairs(ignore_patterns) do
        if line:find(pattern) then
            return true
        end
    end

    return false
end

local function filter(bufnr, diagnostics)
    if not diagnostics or vim.tbl_isempty(diagnostics) then
        return diagnostics
    end

    return vim.tbl_filter(function(diagnostic)
        return not line_has_ignore_marker(bufnr, diagnostic.lnum)
    end, diagnostics)
end

function M.setup()
    if vim.g.richard_diagnostic_filter_loaded then
        return
    end
    vim.g.richard_diagnostic_filter_loaded = true

    local function wrap_handlers()
        for name, handler in pairs(vim.diagnostic.handlers) do
            if type(handler) == "table" and type(handler.show) == "function" and not handler.richard_filtered then
                local show = handler.show
                handler.show = function(namespace, bufnr, diagnostics, opts)
                    return show(namespace, bufnr, filter(bufnr, diagnostics), opts)
                end
                handler.richard_filtered = true
                vim.diagnostic.handlers[name] = handler
            end
        end
    end

    wrap_handlers()

    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = wrap_handlers,
    })
end

return M
