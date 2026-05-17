return {
    { "scottmckendry/cyberdream.nvim", name = "cyberdream" },
    { "olimorris/onedarkpro.nvim", name = "onedarkpro" },
    { "folke/tokyonight.nvim", name = "tokyonight" },
    { "sainnhe/sonokai", name = "sonokai" },
    { "catppuccin/nvim", name = "catppuccin" },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "rose-pine",
            transparent_background = true,
        },
    },
}
