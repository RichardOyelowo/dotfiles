return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.install_dir = vim.fn.stdpath("data") .. "/site"
        end,
    },
}
