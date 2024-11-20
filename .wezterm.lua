-- pull in the wezterm API
local wezterm = require 'wezterm'

-- this will hold the configuration
local config = wezterm.config_builder()

-- config

--- Appearance
--config.color_scheme = 'Belafonte Night (Gogh)'
config.color_scheme = 'Tomorrow (dark) (terminal.sexy)'
--config.color_scheme = 'Twilight (Gogh)'


---- Fonts and window

config.window_background_opacity = 1.0

config.font_size = 14
config.line_height = 1

config.harfbuzz_features = { 'zero' }

config.dpi = 96.0
config.bold_brightens_ansi_colors = true

config.window_padding = {
left = "32pt", 
right = "32pt",
bottom = "32pt",
top = "32pt",
        }


-- SIZE of window:
config.initial_rows = 55
config.initial_cols = 130

config.window_decorations = "RESIZE"

---Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 600


--- Tab Bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false 
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true

config.window_close_confirmation = "NeverPrompt"






-- and finally, return the configuration to wezterm
return config
