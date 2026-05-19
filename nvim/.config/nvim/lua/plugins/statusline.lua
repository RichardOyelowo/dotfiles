local function lsp_clients()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if vim.tbl_isempty(clients) then
        return ""
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    table.sort(names)

    return table.concat(names, ",")
end

return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.sections = opts.sections or {}
            opts.sections.lualine_x = opts.sections.lualine_x or {}
            for _, component in ipairs(opts.sections.lualine_x) do
                if type(component) == "table" and component.richard_lsp_clients then
                    return
                end
            end
            table.insert(opts.sections.lualine_x, 1, {
                lsp_clients,
                cond = function()
                    return lsp_clients() ~= ""
                end,
                icon = "",
                richard_lsp_clients = true,
            })
        end,
    },
}
