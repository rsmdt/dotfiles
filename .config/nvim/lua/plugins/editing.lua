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

			-- Indent guides + scope (replaces indent-blankline.nvim + mini.indentscope).
			-- Default char is "│" (== icons.ui.Line) and special buffers are filtered out.
			indent = { enabled = true },

			-- Notifications (replaces fidget.nvim). `minimal` = no border, just icon +
			-- message (the fidget aesthetic); bottom-up placement like fidget.
			-- NOTE: LSP progress is handled by noice (see lua/plugins/ui.lua).
			notifier = {
				enabled = true,
				style = "minimal",
				top_down = false,
			},

			-- Startup screen (replaces alpha-nvim). Two-pane "Advanced" layout from:
			-- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md#advanced
			-- Left pane: header, keys, startup. Right pane: terminal, recent files,
			-- projects, git status. Custom buttons preserved via preset.keys.
			dashboard = {
				enabled = true,
				preset = {
					keys = {
						{ icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
						{ icon = " ", key = "f", desc = "Find file", action = ":FzfLua files" },
						{ icon = " ", key = "s", desc = "Restore session", section = "session" },
						{ icon = " ", key = "m", desc = "Mason", action = ":Mason" },
						{ icon = " ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{
						pane = 2,
						section = "terminal",
						cmd = "colorscript -e square",
						height = 5,
						padding = 1,
						-- colorscript is an optional external tool; hide this pane when absent
						enabled = function()
							return vim.fn.executable("colorscript") == 1
						end,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
			},

			-- explorer = { enabled = true },
			-- input = { enabled = true },
			-- picker = { enabled = true },
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

	-- Highlight, list, and navigate TODO/FIX/HACK/etc. comments
	-- @see https://github.com/folke/todo-comments.nvim
	{
		"folke/todo-comments.nvim",
		event = "User FileOpened",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next [t]odo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev [t]odo comment",
			},
			{ "<leader>xt", "<CMD>TodoTrouble<CR>", desc = "[T]odos (Trouble)" },
		},
		opts = {},
	},

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
					-- NOTE: TODO/FIXME/HACK/NOTE keyword highlighting is owned by
					-- todo-comments.nvim (gutter signs + project-wide listing).
					-- mini.hipatterns focuses on inline color highlighting below.

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
							local l, c, h = match:match("oklch%(%s*([%d%.]+)%%?%s+([%d%.]+)%s+([%d%.]+)%s*%)")
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
							local l, a, b = match:match("oklab%(%s*([%d%.]+)%%?%s+(%-?[%d%.]+)%s+(%-?[%d%.]+)%s*%)")
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
		opts = {},
	},

	{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },

	-- An interactive and powerful Git interface for Neovim, inspired by Magit
	-- https://github.com/NeogitOrg/neogit
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
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
	--
	-- Migrated to the `main`-branch rewrite (the legacy `master` API was
	-- removed upstream). There is no `nvim-treesitter.configs.setup()` /
	-- central `opts` table anymore:
	--   * parser install -> require("nvim-treesitter").install(...)
	--   * highlighting    -> vim.treesitter.start() in a FileType autocmd
	--   * auto_install    -> install-on-demand inside that autocmd
	-- Dropped (no `main`-branch support): `incremental_selection` (removed
	-- from core) and `nvim-treesitter-textsubjects` (no `main` version).
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects", -- Additional text objects via treesitter (currently unconfigured)
			-- 'nvim-treesitter/playground',                  -- show treesitter info in vim
		},
		event = { "VeryLazy" },
		config = function()
			local ts = require("nvim-treesitter")

			-- the javascript filetype will use the typescript parser
			vim.treesitter.language.register("typescript", "javascript")

			-- Parsers we always want available (was `ensure_installed`).
			-- No-op for parsers that are already installed.
			ts.install({
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
			})

			-- Enable highlighting per-buffer. Folds in the old `highlight`,
			-- large-file `disable`, and `auto_install` options.
			local function enable(buf)
				if not vim.api.nvim_buf_is_valid(buf) then
					return
				end

				-- disable treesitter highlight for large files
				if vim.api.nvim_buf_line_count(buf) > 10000 then
					return
				end

				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang then
					return
				end

				if vim.tbl_contains(ts.get_installed("parsers"), lang) then
					pcall(vim.treesitter.start, buf, lang)
				elseif vim.tbl_contains(ts.get_available(), lang) then
					-- auto-install a missing-but-available parser, then start
					ts.install(lang):await(function(err)
						if err then
							return
						end
						vim.schedule(function()
							if vim.api.nvim_buf_is_valid(buf) then
								pcall(vim.treesitter.start, buf, lang)
							end
						end)
					end)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nvim_treesitter_highlight", { clear = true }),
				callback = function(args)
					enable(args.buf)
				end,
			})

			-- Apply to buffers already open before this plugin lazy-loaded
			-- (VeryLazy), since their FileType event has already fired.
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					enable(buf)
				end
			end
		end,
	},

	-- Show context of the current function
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "User FileOpened",
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
		"gunasekar/markview-smart-tables.nvim",
		dependencies = { "OXY2DEV/markview.nvim" },
		opts = {
			wrap_width = 0.9, -- max table width: fraction of the window (0<n<=1) or absolute column count (n>1)
			wrap_minwidth = 5, -- smallest a column may shrink to before long words are hard-broken
		},
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
