-- Copy this file to ~/.config/wezterm/local.lua for machine-local settings.
-- Keep local.lua out of Git so absolute paths stay private.

local img = "/absolute/path/to/background.jpg"

local file = io.open(img, "r")
if file then
	file:close()

	return {
		window_background_image = img,
		window_background_image_hsb = {
			brightness = 0.2,
			saturation = 0.8,
			hue = 0.5,
		},
	}
end

return {}
