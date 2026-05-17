return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                },
                severity_sort = true,
                underline = true,
                update_in_insert = false,
            },
            inlay_hints = {
                enabled = true,
            },
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                        },
                    },
                },
                pyright = {},
                ruff = {},
                vtsls = {},
                clangd = {},
                html = {},
                cssls = {},
                jsonls = {},
                yamlls = {},
            },
        },
    },
}
