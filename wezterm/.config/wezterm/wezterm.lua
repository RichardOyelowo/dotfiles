local wezterm = require("wezterm")
local mux = wezterm.mux

local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end

	return false
end

local function local_config_paths()
	local paths = {
		wezterm.config_dir .. "/local.lua",
		wezterm.home_dir .. "/dotfiles/wezterm/.config/wezterm/local.lua",
	}

	local dotfiles_home = os.getenv("DOTFILES_HOME") or os.getenv("DOTFILES")
	if dotfiles_home then
		table.insert(paths, dotfiles_home .. "/wezterm/.config/wezterm/local.lua")
	end

	return paths
end

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local config = {
	font = wezterm.font("0xProto Nerd Font Mono"),
	line_height = 1.25,

	default_prog = {
		"zsh",
		"-lc",
		wezterm.home_dir .. "/.local/bin/tmux-sessionizer; unset DEV_TMUX; exec zsh -l",
	},

	enable_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,

	set_environment_variables = {
		DEV_TMUX = "1",
	},

	window_background_opacity = 0.95,
	--kde_window_background_blur = false,
	--macos_window_background_blur = 10,

	color_scheme = "Catppuccin Mocha",

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},

	check_for_updates = false,
}

-- Put machine-local settings in local.lua.
-- Checked locations:
-- 1. ~/.config/wezterm/local.lua
-- 2. ~/dotfiles/wezterm/.config/wezterm/local.lua
-- 3. $DOTFILES_HOME/wezterm/.config/wezterm/local.lua
-- The file is ignored by Git, so local paths stay out of the repo.
for _, local_config in ipairs(local_config_paths()) do
	if file_exists(local_config) then
		local ok, local_overrides = pcall(dofile, local_config)
		if ok and type(local_overrides) == "table" then
			for key, value in pairs(local_overrides) do
				config[key] = value
			end
			break
		end
	end
end

return config
