return {
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        cmd = "Rest",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter",
                opts = function(_, opts)
                    opts.ensure_installed = opts.ensure_installed or {}
                    vim.list_extend(opts.ensure_installed, { "http" })
                end,
            },
        },
        init = function()
            vim.g.rest_nvim = {
                response = {
                    hooks = {
                        format = true,
                    },
                },
                env = {
                    enable = true,
                    pattern = ".*%.env.*",
                },
                highlight = {
                    enable = true,
                    timeout = 750,
                },
            }
        end,
    },
}
