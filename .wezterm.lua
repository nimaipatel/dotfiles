local wezterm = require "wezterm"

function is_dark()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  if result:match("Dark") then
    return true
  else
    return false
  end
end

local color_scheme = nil
local tab_bar = nil

if is_dark() then
  color_scheme = "GruvboxDark"
  tab_bar = {
    background = "#1e1e1e",
    active_tab = { bg_color = "#444444", fg_color = "#ffffff" },
    inactive_tab = { bg_color = "#2e2e2e", fg_color = "#aaaaaa" },
    new_tab = { bg_color = "#2e2e2e", fg_color = "#aaaaaa" },
  }
else
  color_scheme = "GruvboxLight"
  tab_bar = {
    background = "#f0f0f0", 
    active_tab = { bg_color = "#e0e0e0", fg_color = "#333333" }, 
    inactive_tab = { bg_color = "#d0d0d0", fg_color = "#666666" }, 
    new_tab = { bg_color = "#d0d0d0", fg_color = "#666666" }, 
  }
end

return {
  color_scheme = color_scheme,
  colors = { tab_bar = tab_bar },
  window_frame = {
    font = wezterm.font { family = "Menlo", weight = "Bold" },
    active_titlebar_bg = tab_bar.background,
    inactive_titlebar_bg = tab_bar.background,
  },

  font = wezterm.font("Menlo", { weight = "Bold" }),
  harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
  cursor_blink_rate = 0,
  cursor_thickness = 3,
}
