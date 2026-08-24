return {
	-- fancy scrollbar
	{
		"petertriho/nvim-scrollbar",
		event = { "VeryLazy" }, -- "User FileOpened",
		opts = {},
	},

	-- fancy top buffer manager, @see https://github.com/akinsho/bufferline.nvim
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		-- event = "VimEnter",
		event = "User FileOpened",
		keys = {
			{ "<left>", "<CMD> BufferLineCyclePrev <CR>", desc = "Goto left buffer", silent = true },
			{ "<right>", "<CMD> BufferLineCycleNext <CR>", desc = "Goto right buffer", silent = true },
			{ "<S-left>", "<CMD> BufferLineMovePrev <CR>", desc = "Move current buffer to left", silent = true },
			{ "<S-right>", "<CMD> BufferLineMoveNext <CR>", desc = "Move current buffer to right", silent = true },
			{ "<up>", "<CMD> BufferLineCloseOthers <CR>", desc = "Close other buffers", silent = true },
			{ "<down>", ":e#<CR>", desc = "Toggle to previous buffer", silent = true },
		},
		opts = {
			options = {
				separator_style = { "|", "|" }, -- "slant", | "slope" | "thick" | "thin" | { 'any', 'any' },
				diagnostics = "nvim_lsp",
				offsets = {
					-- { filetype = "NvimTree", text = "NvimTree", highlight = "Directory", text_align = "left" },
					{ filetype = "neo-tree", text_align = "left" },
				},
			},
		},
	},

	-- -- A IDE-style winbar for Neovim
	-- {
	-- 	"utilyre/barbecue.nvim",
	-- 	version = "*",
	-- 	dependencies = {
	-- 		"SmiteshP/nvim-navic",
	-- 		"nvim-tree/nvim-web-devicons", -- optional dependency
	-- 	},
	-- 	event = { "VeryLazy" }, -- "User FileOpened",
	-- 	opts = {},
	-- },

	-- Fancier statusline, see `:help lualine.txt`
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "VeryLazy" }, -- "User FileOpened",
		opts = require("configs.lualine"),
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus

			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		config = function(_, opts)
			vim.o.laststatus = vim.g.lualine_laststatus

			require("lualine").setup(opts)
		end,
	},

	-- Notifications are handled by snacks.notifier (see lua/plugins/editing.lua,
	-- style = "minimal" for a fidget-like look). LSP progress is handled by noice
	-- below (lsp.progress.enabled = true).

	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	-- @see https://github.com/folke/noice.nvim
	--
	-- Comes with:
	--  * popup: powered by nui.nvim
	--  * split: powered by nui.nvim
	--  * notife: powered by nvim-notify
	--  * virtualtext: shows the message as virtualtext (for example for search_count)
	--  * mini: similar to notifier.nvim & fidget.nvim
	--  * notify_send: generate a desktop notification
	--
	-- @see https://github.com/folke/noice.nvim?tab=readme-ov-file#-views
	{
		"folke/noice.nvim",
		event = { "VeryLazy" }, -- User FileOpened"},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>n", "<CMD>Noice pick<CR>", desc = "[N]oice" },
			{ "<leader>ne", "<CMD>Noice errors<CR>", desc = "[N]oice [E]errors" },
			{ "<leader>nl", "<CMD>Noice last<CR>", desc = "[N]oice [L]ast" },
			{ "<leader>nh", "<CMD>Noice history<CR>", desc = "[N]oice [H]istory" },
		},
		opts = {
			commands = { all = { view = "popup" } },
			lsp = {
				progress = {
					-- fidget was removed; noice now owns LSP progress display
					enabled = true,
				},
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.utils.convert_input_to_markdown_lines"] = true,
					["vim.lsp.utils.stylize_markdown"] = true,
				},
			},

			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},

			routes = {
				-- hide 'file written' messages
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
		},
	},

	-- fancy resize buffers (with animations)
	{
		"anuvyklack/windows.nvim",
		-- event = "User FileOpened",
		event = "VeryLazy",
		dependencies = {
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
		},
		keys = {
			{ "<C-m>", ":WindowsMaximize<CR>", desc = "[M]aximize current buffer" },
		},
		opts = {
			animation = {
				duration = 150,
			},
		},
		init = function()
			vim.opt.winwidth = 5
			vim.opt.winminwidth = 5
			vim.opt.equalalways = false
		end,
	},

	-- Indentation guides + scope are provided by snacks.indent
	-- (see lua/plugins/editing.lua). Replaced indent-blankline.nvim + mini.indentscope.

	-- The startup greeter is provided by snacks.dashboard
	-- (see lua/plugins/editing.lua). Replaced alpha-nvim.
}
