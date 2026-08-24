return {
	-- Use your Neovim like using Cursor AI IDE!
	-- @see https://github.com/yetone/avante.nvim
	-- "yetone/avante.nvim",

	-- -- AI completion
	-- {
	-- 	"Exafunction/codeium.nvim",
	-- 	cmd = "Codeium",
	-- 	event = "BufEnter", -- "InsertEnter",
	-- 	build = ":Codeium Auth",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	opts = {
	-- 		enable_chat = true,
	-- 	},
	-- },

	-- Completion
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"folke/lazydev.nvim",
		},
		opts = {
			keymap = {
				preset = "none",

				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-h>"] = { "hide", "fallback" },
				["<C-l>"] = { "accept", "fallback" },

				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },

				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},

			completion = {
				list = {
					selection = { preselect = false, auto_insert = false },
				},
				menu = {
					border = "rounded",
				},
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = true },
			},

			signature = {
				enabled = true,
				window = { border = "rounded" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},

			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true } },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}
