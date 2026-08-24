local icons = require("core.icons")
local u = require("core.utils")

-- diagnostics
vim.diagnostic.config({
	virtual_text = true,
	-- virtual_text = {
	-- 	spacing = 2,
	-- 	prefix = "●",
	-- 	source = true, -- "if_many",
	-- },
	virtual_lines = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
})

return {
	-- LSP and tools setup
	{
		"mason-org/mason.nvim",
		version = "^2.0.0", -- quarry.nvim v5 targets the mason.nvim v2 (mason-org) API
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = icons.ui.Check,
					package_pending = icons.ui.CircleDashed,
					package_uninstalled = icons.ui.CircleOutlined,
				},
			},
		},
	},

	-- Faster LuaLS setup for Neovim
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

	{
		"rsmdt/quarry.nvim",
		dir = "/Users/irudi/Code/personal/lua/quarry.nvim", -- local checkout with deferred-setup changes; restore version = "^5.0.0" once released
		event = { "VeryLazy" },
		dependencies = {
			{ "mason-org/mason.nvim", version = "^2.0.0" },
			{ "mason-org/mason-lspconfig.nvim", version = "^2.0.0" },
			"neovim/nvim-lspconfig",

			-- needed for additional capabilities
			-- "hrsh7th/cmp-nvim-lsp",
			"nvim-lua/plenary.nvim",

			-- load own LSP configurations that are handled by quarry.nvim
			{ import = "plugins.languages" },
		},
		opts = {
			features = {
				"textDocument/documentHighlight",
				-- "textDocument/inlayHint",
				-- "textDocument/codeLens",
			},

			keys = {
				["gs"] = { vim.lsp.buf.signature_help, desc = "[G]oto [s]ignature" },
				["gD"] = { vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
				["gd"] = { vim.lsp.buf.definition, desc = "[G]oto [d]efinition" },
				["gr"] = { vim.lsp.buf.references, desc = "[G]oto [r]eferences" },
				["gi"] = { vim.lsp.buf.implementation, desc = "[G]oto [i]mplementation" },
				["gt"] = { vim.lsp.buf.type_definition, desc = "Goto [t]ype definition" },

				["[d"] = {
					function()
						vim.diagnostic.jump({ count = -1 })
					end,
				},
				["]d"] = {
					function()
						vim.diagnostic.jump({ count = 1 })
					end,
				},
				["<leader>q"] = { vim.diagnostic.setloclist, desc = "Open [Q]uickfix list" },

				["K"] = { vim.lsp.buf.hover, desc = "Show lsp hover" },
				-- ["<C-k>"] = { vim.lsp.buf.signature_help, desc = "Signature Help" },

				["<leader>a"] = { vim.lsp.buf.code_action, desc = "Code [a]ction" },
				["<leader>r"] = { vim.lsp.buf.rename, desc = "[R]ename word under cursor within project" },

				["<leader>h"] = {
					function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end,
					desc = "Toggle inlay [h]int",
				},

				["<C-space>"] = { "<C-x><C-o>", mode = "i", remap = false },
			},

			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			end,

			capabilities = function()
				local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities())

				if u.has("blink.cmp") then
					capabilities =
						vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
				end

				return capabilities
			end,
		},
		config = function(_, opts)
			-- overwrite kaymaps if fzf-lua is available
			if u.has("fzf-lua") then
				opts.keys["gd"] = { "<CMD>FzfLua lsp_definitions<CR>", desc = "[G]oto [d]efinition" }
				opts.keys["gr"] = { "<CMD>FzfLua lsp_references<CR>", desc = "[G]oto [r]eferences" }
				opts.keys["gi"] = { "<CMD>FzfLua lsp_implementations<CR>", desc = "[G]oto [i]mplementation" }
				opts.keys["gt"] = { "<CMD>FzfLua lsp_typedefs<CR>", desc = "[G]oto [t]ype definition" }
			end

			-- remap code action
			if u.has("fastaction.nvim") then
				opts.keys["<leader>a"] = {
					function()
						require("fastaction").code_action()
					end,
					desc = "Code [a]ction",
				}
			end

			require("quarry").setup(opts)
		end,
	},

	-- @see https://github.com/Chaitanyabsprip/fastaction.nvim
	{
		"Chaitanyabsprip/fastaction.nvim",
		event = { "VeryLazy" },
		opts = {
			dismiss_keys = { "j", "k", "<c-c>", "q", "<esc>" },
			-- priority = {
			-- 	javascript = {
			-- 		{ pattern = "add import", key = "a", order = 1 },
			-- 	},
			-- },
		},
	},

	-- Code outline sidebar powered by LSP.
	--
	-- @see https://github.com/hedyhli/outline.nvim
	-- For default config and keymaps, @see here: https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#default-options
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<CMD>Outline<CR>", desc = "Show Symbols [O]utline" },
		},
		opts = {
			outline_window = {
				width = 45,
				relative_width = false,
			},
			preview_window = {
				-- Automatically open preview of code location when navigating outline window
				auto_preview = true,
			},
		},
	},
}
