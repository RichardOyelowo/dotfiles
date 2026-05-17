return {
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = false,
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            signature = {
                enabled = true,
            },
        },
    },
}
