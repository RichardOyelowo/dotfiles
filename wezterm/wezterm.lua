local wezterm = require("wezterm")

return {
    font = wezterm.font("0xProto Nerd Font Mono"),
    font_size = 12.5,
    line_height = 1.25,

    enable_tab_bar = false,
    hide_tab_bar_if_only_one_tab = true,

    window_background_opacity = 0.88,

    window_padding = {
        left = 12,
        right = 12,
        top = 12,
        bottom = 12,
    },

    colors = {
        foreground = "#e0e0f0",
            background = "#000000",

            cursor_bg = "#ff79c6",
            cursor_fg = "#0a0c1f",
            cursor_border = "#ff79c6",

            ansi = {
                "#0c0c17",
                "#ff5c57",
                "#5af78e",
                "#f3f99d",
                "#57c7ff",
                "#ff6ac1",
                "#9aedfe",
                "#f1f1f0",
            },

            brights = {
                "#1a1a2e",
                "#ff5c57",
                "#5af78e",
                "#f3f99d",
                "#57c7ff",
                "#ff6ac1",
                "#9aedfe",
                "#f1f1f0",
            },
    },

    check_for_updates = false,
}
