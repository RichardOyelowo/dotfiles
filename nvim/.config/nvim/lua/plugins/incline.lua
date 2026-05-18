local function filename(props)
    local name = vim.api.nvim_buf_get_name(props.buf)
    if name == "" then
        return "[No Name]"
    end

    return vim.fn.fnamemodify(name, ":t")
end

return {
    {
        "b0o/incline.nvim",
        event = "BufReadPre",
        dependencies = {
            "nvim-mini/mini.icons",
        },
        opts = {
            hide = {
                cursorline = true,
            },
            window = {
                padding = 0,
                margin = {
                    horizontal = 0,
                    vertical = 0,
                },
            },
            render = function(props)
                local file = filename(props)
                local icon, icon_hl = MiniIcons.get("file", file)
                local modified = vim.bo[props.buf].modified

                return {
                    { " ", icon, " ", group = icon_hl },
                    " ",
                    { file, gui = modified and "bold,italic" or "bold" },
                    modified and { " 󰏫", group = "DiagnosticWarn" } or "",
                    " ",
                    guibg = "#0d1224",
                    guifg = "#cdd6f4",
                }
            end,
        },
    },
}
