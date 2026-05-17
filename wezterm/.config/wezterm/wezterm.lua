local wezterm = require("wezterm")

return {
	font = wezterm.font("0xProto Nerd Font Mono"),
	font_size = 12.5,
	line_height = 1.25,

	enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	set_environment_variables = {
		DEV_TMUX = "1",
	},

	window_background_opacity = 0.92,
	macos_window_background_blur = 20,

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},

	colors = {
		foreground = "#e0e0f0",
		background = "#000000",

		cursor_bg = "#e0e0f5",
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
