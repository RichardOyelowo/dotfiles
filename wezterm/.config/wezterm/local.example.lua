-- Copy this file to ~/.config/wezterm/local.lua for machine-local settings.
-- Keep local.lua out of Git so absolute image paths stay private.

return {
	-- Use an absolute path on this machine.
	-- window_background_image = "/absolute/path/to/background.jpg",

	-- Keep the image dark enough that terminal text stays readable.
	window_background_image_hsb = {
		brightness = 0.04,
		saturation = 0.8,
		hue = 0.5,
	},
}
