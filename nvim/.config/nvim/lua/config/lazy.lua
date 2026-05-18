local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        -- LazyVim base
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },

        -- Language / development extras
        { import = "lazyvim.plugins.extras.lang.sql" },
        { import = "lazyvim.plugins.extras.lang.rust" },
        { import = "lazyvim.plugins.extras.lang.clangd" },
        { import = "lazyvim.plugins.extras.lang.python" },
        { import = "lazyvim.plugins.extras.lang.typescript" },
        { import = "lazyvim.plugins.extras.lang.git" },
        { import = "lazyvim.plugins.extras.lang.json" },
        { import = "lazyvim.plugins.extras.lang.yaml" },
        { import = "lazyvim.plugins.extras.lang.docker" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
        { import = "lazyvim.plugins.extras.lang.tailwind" },

        -- Editor extras
        { import = "lazyvim.plugins.extras.editor.snacks_picker" },
        { import = "lazyvim.plugins.extras.editor.snacks_explorer" },
        { import = "plugins" },
    },

    defaults = {
        -- LazyVim plugins are lazy-loaded by default.
        -- Your custom plugins load at startup unless you set lazy = true.
        lazy = false,

        -- Recommended by LazyVim/lazy.nvim.
        -- Many plugins have outdated tagged releases.
        version = false,
    },

    install = {
        colorscheme = { "tokyonight" },
    },

    checker = {
        enabled = true,
        notify = false,
    },

    rocks = {
        hererocks = true,
    },

    performance = {
        rtp = {
            -- Fix Treesitter health warning:
            -- /home/Richard_O/.local/share/nvim/site is writable but not in runtimepath
            paths = {
                vim.fn.stdpath("data") .. "/site",
            },

            -- Disable unused built-in runtime plugins
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
