return {
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = false,

            formatters_by_ft = {
                lua = { "stylua" },

                python = { "ruff_organize_imports", "ruff_format", stop_after_first = false },

                javascript = { "biome", "prettier", stop_after_first = true },
                javascriptreact = { "biome", "prettier", stop_after_first = true },
                typescript = { "biome", "prettier", stop_after_first = true },
                typescriptreact = { "biome", "prettier", stop_after_first = true },

                html = { "prettier" },
                css = { "biome", "prettier", stop_after_first = true },
                scss = { "prettier" },
                less = { "prettier" },

                json = { "biome", "prettier", stop_after_first = true },
                jsonc = { "biome", "prettier", stop_after_first = true },
                yaml = { "prettier" },
                toml = { "taplo" },

                markdown = { "prettier" },
                ["markdown.mdx"] = { "prettier" },

                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },

                c = { "clang-format" },
                cpp = { "clang-format" },

                rust = { "rustfmt" },
                sql = { "sqlfluff" },
                dockerfile = { "dockerfmt" },

                ["_"] = { "trim_whitespace" },
            },
        },
    },
}
