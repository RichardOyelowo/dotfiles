local project_tools = require("config.project_tools")

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
                pyright = {
                    before_init = function(_, config)
                        local root_dir = config.root_dir or vim.fn.getcwd()
                        config.settings = config.settings or {}
                        config.settings.python = config.settings.python or {}
                        config.settings.python.pythonPath = project_tools.python(root_dir)
                    end,
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                indexing = false,
                                useLibraryCodeForTypes = true,
                                exclude = {
                                    "**/.git",
                                    "**/.mypy_cache",
                                    "**/.pytest_cache",
                                    "**/.ruff_cache",
                                    "**/.tox",
                                    "**/.venv",
                                    "**/__pycache__",
                                    "**/build",
                                    "**/dist",
                                    "**/node_modules",
                                    "**/venv",
                                },
                                diagnosticSeverityOverrides = {
                                    reportUnusedImport = "none",
                                },
                            },
                        },
                    },
                },
                ruff = {
                    before_init = function(_, config)
                        local root_dir = config.root_dir or vim.fn.getcwd()
                        config.init_options = config.init_options or {}
                        config.init_options.settings = config.init_options.settings or {}
                        config.init_options.settings.interpreter = { project_tools.python(root_dir) }
                    end,
                },
                vtsls = {
                    before_init = function(_, config)
                        local root_dir = config.root_dir or vim.fn.getcwd()
                        local tsdk = project_tools.typescript_sdk(root_dir)
                        if not tsdk then
                            return
                        end

                        config.settings = config.settings or {}
                        config.settings.typescript = config.settings.typescript or {}
                        config.settings.javascript = config.settings.javascript or {}
                        config.settings.typescript.tsdk = tsdk
                        config.settings.javascript.tsdk = tsdk
                    end,
                },
                clangd = {},
                html = {},
                cssls = {},
                jsonls = {},
                yamlls = {},
            },
        },
    },
}
