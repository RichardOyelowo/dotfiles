local function set_transparent_background()
    local groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "WinSeparator",
    }

    local preserve = {
        "fg",
        "sp",
        "blend",
        "bold",
        "standout",
        "underline",
        "undercurl",
        "underdouble",
        "underdotted",
        "underdashed",
        "strikethrough",
        "italic",
        "reverse",
        "nocombine",
        "ctermfg",
        "ctermbg",
        "cterm",
    }

    for _, group in ipairs(groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, {
            name = group,
            link = false,
        })

        if ok and hl then
            local new_hl = {}

            for _, key in ipairs(preserve) do
                if hl[key] ~= nil then
                    new_hl[key] = hl[key]
                end
            end

            new_hl.bg = "NONE"
            vim.api.nvim_set_hl(0, group, new_hl)
        end
    end
end

return {
    {
        "nvim-mini/mini.icons",
        lazy = false,
        opts = {
            file = {
                [".env"] = { glyph = "", hl = "MiniIconsYellow" },
                [".env.example"] = { glyph = "", hl = "MiniIconsGrey" },
                ["pyproject.toml"] = { glyph = "", hl = "MiniIconsYellow" },
                ["requirements.txt"] = { glyph = "", hl = "MiniIconsYellow" },
                ["Dockerfile"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
                ["docker-compose.yml"] = { glyph = "󰡨", hl = "MiniIconsAzure" },
            },
            filetype = {
                python = { glyph = "", hl = "MiniIconsYellow" },
                sql = { glyph = "", hl = "MiniIconsBlue" },
                dockerfile = { glyph = "󰡨", hl = "MiniIconsAzure" },
            },
        },
    },

    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = {
            smear_between_buffers = true,
            smear_between_neighbor_lines = true,
            scroll_buffer_space = true,
            stiffness = 0.86,
            trailing_stiffness = 0.28,
            stiffness_insert_mode = 0.75,
            trailing_stiffness_insert_mode = 0.28,
            damping = 0.92,
            damping_insert_mode = 0.9,
            distance_stop_animating = 0.5,
            time_interval = 7,
            legacy_computing_symbols_support = true,
        },
    },

    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    files = {
                        hidden = true,
                    },
                    grep = {
                        hidden = true,
                    },
                    explorer = {
                        hidden = true,
                    },
                },
            },
        },
    },

    {
        "LazyVim/LazyVim",
        opts = {
            transparent_background = true,
        },
        init = function()
            vim.api.nvim_create_autocmd("ColorScheme", {
                group = vim.api.nvim_create_augroup("GlobalTransparentBackground", { clear = true }),
                callback = set_transparent_background,
            })

            vim.api.nvim_create_autocmd("VimEnter", {
                group = vim.api.nvim_create_augroup("InitialTransparentBackground", { clear = true }),
                callback = set_transparent_background,
            })
        end,
    },
}
