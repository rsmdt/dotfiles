local icons = require("core.icons")

local wincmd_for_direction = { left = "h", down = "j", up = "k", right = "l" }
local tmux_command_for_direction = { left = "Left", down = "Down", up = "Up", right = "Right" }

local function focus_herdr_pane(direction)
	local herdr = vim.env.HERDR_BIN_PATH
	if herdr == nil or herdr == "" then
		herdr = "herdr"
	end
	vim.fn.system({ herdr, "pane", "focus", "--direction", direction, "--pane", vim.env.HERDR_PANE_ID })
end

local function navigate_split_or_pane(direction)
	local window_before = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. wincmd_for_direction[direction])

	if vim.api.nvim_get_current_win() ~= window_before then
		return
	end

	if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
		focus_herdr_pane(direction)
	elseif vim.env.TMUX and vim.env.TMUX ~= "" then
		pcall(vim.cmd, "TmuxNavigate" .. tmux_command_for_direction[direction])
	end
end

return {
	{ import = "plugins.navigation" },

	-- Navigate your code with search labels, enhanced character motions and Treesitter integration
	-- @see https://github.com/folke/flash.nvim
	{
		"folke/flash.nvim",
		event = "VeryLazy", -- "User FileOpened"
		opts = {
			modes = { char = { jump_labels = true } },
		},
	},

	-- @see https://github.com/paulbkim-dev/vim-herdr-navigation
	{
		"christoomey/vim-tmux-navigator",
		cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
		init = function()
			vim.g.tmux_navigator_no_mappings = 1

			for lhs, direction in pairs({
				["<C-h>"] = "left",
				["<C-j>"] = "down",
				["<C-k>"] = "up",
				["<C-l>"] = "right",
			}) do
				vim.keymap.set("n", lhs, function()
					navigate_split_or_pane(direction)
				end, { silent = true, noremap = true, desc = "Navigate " .. direction .. " (split/pane)" })
			end
		end,
	},

	-- multiple cursors
	{ "mg979/vim-visual-multi", lazy = true },

	-- Session management: auto-saves on exit, restores per working directory.
	-- Also powers the "Restore session" button on the snacks dashboard.
	-- @see https://github.com/folke/persistence.nvim
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		keys = {
			{
				"<leader>Ss",
				function()
					require("persistence").load()
				end,
				desc = "Restore [S]ession (cwd)",
			},
			{
				"<leader>Sl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore [S]ession (last)",
			},
			{
				"<leader>Sd",
				function()
					require("persistence").stop()
				end,
				desc = "[S]ession: stop saving",
			},
		},
		opts = {},
	},

	-- displays a popup with possible key bindings of the command
	{
		"folke/which-key.nvim",
		event = { "VeryLazy" }, -- User FileOpened"},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
		opts = {
			preset = "helix",
		},
	},
}
