local M = {}

---
-- check if plugin is defined in Lazy
--
---@param name string The name of the plugin
function M.has(name)
	return require("lazy.core.config").spec.plugins[name] ~= nil
end

-- ui function to get foreground color of specified highlight group
function M.fg(name)
	local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
		or vim.api.nvim_get_hl_by_name(name, true)
	local fg = hl and (hl.fg or hl.foreground)

	return fg and { fg = string.format("#%06x", fg) } or nil
end

function M.debounce(ms, fn)
	local timer = vim.loop.new_timer()

	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

-- Color conversion utilities for mini.hipatterns

--- Convert HSL to RGB
---@param h number Hue (0-360)
---@param s number Saturation (0-100)
---@param l number Lightness (0-100)
---@return number, number, number RGB values (0-255)
function M.hsl_to_rgb(h, s, l)
	h, s, l = h % 360, s / 100, l / 100
	local function f(n)
		local k = (n + h / 30) % 12
		local a = s * math.min(l, 1 - l)
		return l - a * math.max(-1, math.min(k - 3, 9 - k, 1))
	end
	return math.floor(f(0) * 255 + 0.5), math.floor(f(8) * 255 + 0.5), math.floor(f(4) * 255 + 0.5)
end

--- Convert HSL to hex color
---@param h number Hue (0-360)
---@param s number Saturation (0-100)
---@param l number Lightness (0-100)
---@return string Hex color (#RRGGBB)
function M.hsl_to_hex(h, s, l)
	local r, g, b = M.hsl_to_rgb(h, s, l)
	return string.format("#%02x%02x%02x", r, g, b)
end

--- Convert OKLCH to RGB (approximate conversion via OKLab)
---@param l number Lightness (0-1 or 0-100)
---@param c number Chroma (0-0.4 typical)
---@param h number Hue (0-360)
---@return number, number, number RGB values (0-255)
function M.oklch_to_rgb(l, c, h)
	-- Normalize lightness if provided as percentage
	if l > 1 then
		l = l / 100
	end

	-- Convert OKLCH to OKLab
	local h_rad = math.rad(h)
	local a = c * math.cos(h_rad)
	local b = c * math.sin(h_rad)

	-- OKLab to linear RGB (simplified approximation)
	local l_ = l + 0.3963377774 * a + 0.2158037573 * b
	local m_ = l - 0.1055613458 * a - 0.0638541728 * b
	local s_ = l - 0.0894841775 * a - 1.2914855480 * b

	local l3 = l_ * l_ * l_
	local m3 = m_ * m_ * m_
	local s3 = s_ * s_ * s_

	local r_linear = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3
	local g_linear = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3
	local b_linear = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3

	-- Linear RGB to sRGB with gamma correction
	local function linear_to_srgb(c_linear)
		c_linear = math.max(0, math.min(1, c_linear))
		if c_linear <= 0.0031308 then
			return c_linear * 12.92
		else
			return 1.055 * math.pow(c_linear, 1 / 2.4) - 0.055
		end
	end

	local r = math.floor(linear_to_srgb(r_linear) * 255 + 0.5)
	local g = math.floor(linear_to_srgb(g_linear) * 255 + 0.5)
	local b = math.floor(linear_to_srgb(b_linear) * 255 + 0.5)

	return math.max(0, math.min(255, r)), math.max(0, math.min(255, g)), math.max(0, math.min(255, b))
end

--- Convert OKLCH to hex color
---@param l number Lightness (0-1 or 0-100)
---@param c number Chroma (0-0.4 typical)
---@param h number Hue (0-360)
---@return string Hex color (#RRGGBB)
function M.oklch_to_hex(l, c, h)
	local r, g, b = M.oklch_to_rgb(l, c, h)
	return string.format("#%02x%02x%02x", r, g, b)
end

return M
