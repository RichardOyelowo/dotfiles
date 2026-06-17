return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            automatic_enable = true,
        },
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                -- LSP
                "pyright",
                "lua-language-server",
                "vtsls",
                "clangd",
                "html-lsp",
                "css-lsp",
                "json-lsp",
                "yaml-language-server",
                "docker-language-server",

                -- formatters
                "stylua",
                "prettier",
                "biome",
                "clang-format",
                "shfmt",
                "taplo",
                "sqlfluff",

                -- linters
                "ruff",
                "eslint_d",
                "shellcheck",
                "hadolint",

                -- DAP
                "debugpy",
                "codelldb",
                "js-debug-adapter",
            },
            run_on_start = true,
            start_delay = 5000,
        },
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            automatic_installation = false,
            ensure_installed = {
                "python",
                "codelldb",
                "js",
            },
            handlers = nil,
        },
        event = "VeryLazy",
    },
}
