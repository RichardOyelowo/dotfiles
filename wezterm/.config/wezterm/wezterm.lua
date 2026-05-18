local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local config = {
	font = wezterm.font("0xProto Nerd Font Mono"),
	font_size = 12.5,
	line_height = 1.25,

	default_prog = { wezterm.home_dir .. "/.local/bin/tmux-sessionizer" },

	enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	set_environment_variables = {
		DEV_TMUX = "1",
	},

	window_background_opacity = 0.94,
	kde_window_background_blur = false,
	macos_window_background_blur = 0,

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

-- Put machine-local settings in ~/.config/wezterm/local.lua.
-- That file is ignored by Git, so local paths stay out of the repo.
-- Example:
-- return {
--   window_background_image = "/absolute/path/to/background.jpg",
--   window_background_image_hsb = {
--     brightness = 0.04,
--     saturation = 0.8,
--     hue = 0.5,
--   },
-- }
local local_config = wezterm.config_dir .. "/local.lua"
local ok, local_overrides = pcall(dofile, local_config)
if ok and type(local_overrides) == "table" then
	for key, value in pairs(local_overrides) do
		config[key] = value
	end
end

return config
