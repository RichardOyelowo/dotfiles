local M = {}

local ignore_marker = "nvim%-diagnostic%-ignore"

local function line_has_ignore_marker(bufnr, lnum)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, lnum, lnum + 1, false)
    if not ok or not lines[1] then
        return false
    end

    local line = lines[1]:lower()
    return line:find(ignore_marker) ~= nil
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

    for name, handler in pairs(vim.diagnostic.handlers) do
        if type(handler) == "table" and type(handler.show) == "function" then
            local show = handler.show
            handler.show = function(namespace, bufnr, diagnostics, opts)
                return show(namespace, bufnr, filter(bufnr, diagnostics), opts)
            end
            vim.diagnostic.handlers[name] = handler
        end
    end
end

return M
