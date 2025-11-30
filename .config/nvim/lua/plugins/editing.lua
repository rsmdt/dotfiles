return {

	-- 🍿 A collection of QoL plugins for Neovim
	-- @see https://github.com/folke/snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,

		---@type snacks.Config
		opts = {
			bigfile = { enabled = true }, -- Disable features in large files
			quickfile = { enabled = true }, -- Faster file opening
			statuscolumn = { enabled = true }, -- Better statuscolumn
			words = { enabled = true }, -- Highlight word under cursor (like vim-illuminate)
			-- scroll = { enabled = true }, -- Smooth scrolling (disabled - prefer instant scroll)
			-- dashboard = { enabled = true },
			-- explorer = { enabled = true },
			-- indent = { enabled = true },
			-- input = { enabled = true },
			-- picker = { enabled = true },
			-- notifier = { enabled = true },
			-- scope = { enabled = true },
		},
		keys = {
			{
				"]]",
				function()
					require("snacks.words").jump(vim.v.count1)
				end,
				desc = "Next Reference",
			},
			{
				"[[",
				function()
					require("snacks.words").jump(-vim.v.count1)
				end,
				desc = "Prev Reference",
			},
			{
				"<leader>uw",
				function()
					require("snacks").words.toggle()
				end,
				desc = "Toggle Word Highlighting",
			},
		},
	},

	--- Enhance builtin native comments
	-- 'gc' / 'gcc' to comment visual regions/lines
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		opts = {},
	},

	-- open file given a line, e.g. vim index.html:20
	{ "bogado/file-line", event = "User FileOpened" },

	-- Highlight hex colors and Tailwind CSS classes inline
	-- @see https://github.com/nvim-mini/mini.hipatterns
	{
		"nvim-mini/mini.hipatterns",
		event = "VeryLazy",
		opts = function()
			local hi = require("mini.hipatterns")
			local utils = require("core.utils")

			return {
				highlighters = {
					-- Highlight a fixed set of common words. Will be highlighted in any place, not only in comments.
					fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
					hack = { pattern = "HACK", group = "MiniHipatternsHack" },
					todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
					note = { pattern = "NOTE", group = "MiniHipatternsNote" },

					-- Highlight hex colors like #ff0000
					hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),

					-- Highlight shorthand hex colors like #f00
					shorthand = {
						pattern = "()#%x%x%x()%f[^%x%w]",
						group = function(_, _, data)
							---@type string
							local match = data.full_match
							local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
							local hex_color = "#" .. r .. r .. g .. g .. b .. b

							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},

					-- Highlight RGB colors like rgb(255, 0, 0) or rgb(255 0 0)
					rgb_color = {
						pattern = "rgb%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)",
						group = function(_, match)
							local r, g, b = match:match("rgb%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
							r, g, b = tonumber(r), tonumber(g), tonumber(b)
							if not r or not g or not b then
								return nil
							end
							local hex_color = string.format("#%02x%02x%02x", r, g, b)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},

					-- Highlight HSL colors like hsl(120, 100%, 50%) or hsl(120 100% 50%)
					hsl_color = {
						pattern = "hsl%(%s*%d+%s*,?%s*%d+%%?%s*,?%s*%d+%%?%s*%)",
						group = function(_, match)
							local h, s, l = match:match("hsl%(%s*(%d+)%s*,?%s*(%d+)%%?%s*,?%s*(%d+)%%?%s*%)")
							h, s, l = tonumber(h), tonumber(s), tonumber(l)
							if not h or not s or not l then
								return nil
							end
							local hex_color = utils.hsl_to_hex(h, s, l)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},

					-- Highlight OKLCH colors like oklch(0.5 0.2 180) or oklch(50% 0.2 180)
					-- Format: oklch(lightness chroma hue)
					-- Lightness: 0-1 or 0-100%
					-- Chroma: typically 0-0.4
					-- Hue: 0-360 degrees
					oklch_color = {
						pattern = "oklch%(%s*[%d%.]+%%?%s+[%d%.]+%s+%d+%.?%d*%s*%)",
						group = function(_, match)
							local l, c, h =
								match:match("oklch%(%s*([%d%.]+)%%?%s+([%d%.]+)%s+([%d%.]+)%s*%)")
							l, c, h = tonumber(l), tonumber(c), tonumber(h)
							if not l or not c or not h then
								return nil
							end
							local hex_color = utils.oklch_to_hex(l, c, h)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},

					-- Highlight OKLAB colors like oklab(0.5 0.1 -0.1) or oklab(50% 0.1 -0.1)
					-- Format: oklab(lightness a b)
					oklab_color = {
						pattern = "oklab%(%s*[%d%.]+%%?%s+%-?[%d%.]+%s+%-?[%d%.]+%s*%)",
						group = function(_, match)
							local l, a, b =
								match:match("oklab%(%s*([%d%.]+)%%?%s+(%-?[%d%.]+)%s+(%-?[%d%.]+)%s*%)")
							l, a, b = tonumber(l), tonumber(a), tonumber(b)
							if not l or not a or not b then
								return nil
							end

							-- Normalize lightness if provided as percentage
							if l > 1 then
								l = l / 100
							end

							-- OKLab to linear RGB
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
							local b_val = math.floor(linear_to_srgb(b_linear) * 255 + 0.5)

							r = math.max(0, math.min(255, r))
							g = math.max(0, math.min(255, g))
							b_val = math.max(0, math.min(255, b_val))

							local hex_color = string.format("#%02x%02x%02x", r, g, b_val)
							return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
						end,
						extmark_opts = { priority = 2000 },
					},
				},
			}
		end,
	},

	-- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Trouble",
		opts = {},
	},

	-- Neovim Lua plugin to extend and create `a`/`i` textobjects.
	-- @see https://github.com/nvim-mini/mini.ai
	{
		"nvim-mini/mini.ai",
		event = { "VeryLazy", "User FileOpened" },
		opts = {},
	},

	-- Surround manipulation (add/delete/replace quotes, brackets, tags, etc.)
	-- @see https://github.com/nvim-mini/mini.surround
	{
		"nvim-mini/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		},
	},

	-- Neovim Lua plugin to automatically manage character pairs / autopairs.
	-- https://github.com/windwp/nvim-autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = {},
	},

	{ "sindrets/diffview.nvim" },

	-- An interactive and powerful Git interface for Neovim, inspired by Magit
	-- https://github.com/NeogitOrg/neogit
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			-- "nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			-- "nvim-mini/mini.pick", -- optional
			-- "folke/snacks.nvim", -- optional
		},
	},

	-- git in signcolumn, see `:help gitsigns.txt`
	{
		"lewis6991/gitsigns.nvim",
		event = { "VeryLazy" },
		opts = {
			on_attach = function(bufnr)
				local nmap = function(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				nmap("]c", function()
					if vim.wo.diff then
						return "]c"
					end

					vim.schedule(function()
						require("gitsigns").next_hunk()
					end)

					return "<Ignore>"
				end, "(Git) next hunk")

				nmap("[c", function()
					if vim.wo.diff then
						return "[c"
					end

					vim.schedule(function()
						require("gitsigns").prev_hunk()
					end)

					return "<Ignore>"
				end, "(Git) prev hunk")

				-- Actions
				nmap("<leader>gs", require("gitsigns").stage_buffer, "[G]it [S]tage buffer")
				nmap("<leader>gr", require("gitsigns").reset_buffer, "[G]it [R]eset buffer")
				nmap("<leader>gd", require("gitsigns").toggle_deleted, "[G]it toggle [D]eleted")
			end,
		},
	},

	-- Neovim plugin for splitting/joining blocks of code
	-- @see https://github.com/Wansmer/treesj
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSJToggle",
		keys = {
			{ "<leader>j", "<CMD>TSJToggle<CR>", desc = "Join Toggle" },
			-- { "J", "<CMD>TSJToggle<CR>", desc = "Join Toggle" },
		},
		opts = {
			use_default_keymaps = false,
			max_join_length = 150,
			on_error = function()
				-- fallback to  standard join behaviour
				vim.cmd("join")
			end,
		},
	},

	-- Highlight, edit, and navigate code, see `:help nvim-treesitter`
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- Additional text objects via treesitter
			"RRethy/nvim-treesitter-textsubjects", -- Location and syntax aware text objects which *do what you mean*
			-- 'nvim-treesitter/playground',                  -- show treesitter info in vim
		},
		build = ":TSUpdate",

		event = { "VeryLazy" },
		opts = {
			auto_install = true,

			ensure_installed = {
				"vim",
				"regex",
				"lua",
				"bash",
				"markdown",
				"markdown_inline",
				"tsx",
				"typescript",
				"rust",
				"toml",
			},
			ignore_install = { "javascript" },

			-- indent = {
			-- 	enable = true,
			-- },

			highlight = {
				enable = true,
				use_languagetree = true,

				-- disable treesitter highlight for large files
				disable = function(_, bufnr) -- Disable in large C++ buffers
					-- return lang == "cpp" and api.nvim_buf_line_count(bufnr) > 50000
					return vim.api.nvim_buf_line_count(bufnr) > 10000
				end,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},

			-- nvim-treesitter-textsubjects plugin
			textsubjects = {
				enable = true,
				-- prev_selection = ",", -- (Optional) keymap to select the previous selection
				keymaps = {
					["."] = "textsubjects-smart",
					[";"] = "textsubjects-container-outer",
					-- ["i;"] = "textsubjects-container-inner",
					["i;"] = {
						"textsubjects-container-inner",
						desc = "Select inside containers (classes, functions, etc.)",
					},
				},
			},
		},
		config = function(_, opts)
			vim.treesitter.language.register("typescript", "javascript") -- the javascript filetype will use the tsx parser

			require("nvim-treesitter.configs").setup(opts)

			-- -- Show treesitter capture group for textobject under cursor (nvim-treesitter/playground)
			-- vim.keymap.set('n', '<C-e>', ':TSHighlightCapturesUnderCursor<CR>', { noremap = true, silent = true })
		end,
	},

	-- Show context of the current function
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = { mode = "cursor", max_lines = 3 },
		keys = {
			{
				"<leader>ut",
				function()
					local tsc = require("treesitter-context")
					tsc.toggle()

					if tsc.enabled() then
						vim.notify("Treesitter Context enabled", vim.log.levels.DEBUG)
					else
						vim.notify("Treesitter Context disabled", vim.log.levels.DEBUG)
					end
				end,
				desc = "Toggle Treesitter Context",
			},
		},
	},

	-- Use treesitter to auto close and auto rename html tag
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		opts = {
			opts = {
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = false, -- Auto close on trailing </
			},
		},
	},

	-- Markdown preview inside NeoVim
	-- @see https://github.com/OXY2DEV/markview.nvim
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
	},

	{
		"3rd/diagram.nvim",
		dependencies = { "3rd/image.nvim" },
		opts = {
			-- integrations = {
			-- 	require("diagram.integrations.markdown"),
			-- 	require("diagram.integrations.neorg"),
			-- },
			events = {
				render_buffer = {}, -- Empty = no automatic rendering
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					theme = "dark",
					scale = 2,
				},
			},
		},
		keys = {
			{
				"<leader>d", -- "K",
				function()
					require("diagram").show_diagram_hover()
				end,
				mode = "n",
				ft = { "markdown", "norg" },
				desc = "Show diagram in new tab",
			},
		},
	},

	-- Snapshot plugin with rich features that can make pretty code snapshots for Neovim
	-- @see https://github.com/mistricky/codesnap.nvim
	{
		"mistricky/codesnap.nvim",
		build = "make build_generator",
		keys = {
			{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
			{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot" },
		},
		opts = {
			watermark = "made with love",
			code_font_family = "FiraCode Nerd Font",
			save_path = "~/Desktop",
			-- has_breadcrumbs = true,
			-- bg_theme = "bamboo",
		},
	},
}
