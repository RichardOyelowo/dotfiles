return {
    {
        "mfussenegger/nvim-lint",

        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "ruff" },
                javascript = { "biomejs" },
                typescript = { "biomejs" },
                javascriptreact = { "biomejs" },
                typescriptreact = { "biomejs" },
                sh = { "shellcheck" },
                cpp = { "clangtidy" },
                c = { "clangtidy" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
