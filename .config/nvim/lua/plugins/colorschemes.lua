-- local function colorscheme(profile, spec)
-- 	local term_profile = os.getenv("ITERM_PROFILE") or os.getenv("TERM_PROFILE") or ""
--
-- 	if term_profile:match(profile) then
-- 		if type(spec.init) == "function" then
-- 			spec.init()
-- 		end
--
-- 		-- vim.notify(vim.inspect(spec))
-- 		vim.cmd.colorscheme(spec.colorscheme)
-- 	end
-- end

return {
	-- detect colorscheme based on OS light/dark appearance
	{
		"cormacrelf/dark-notify",
		lazy = false,
		priority = 1000,
		config = function()
			require("dark_notify").run({
				schemes = {
					dark = "tokyonight-night",
					light = "tokyonight-day",
				},
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = {
			on_colors = function(colors)
				colors.border = "#101010"
			end,
		},
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		priority = 1000,
		opts = {
			options = {
				styles = {
					comments = "italic", -- normal
				},
			},
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
	},
}
