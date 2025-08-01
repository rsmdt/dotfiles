return {
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "FzfLua",
		keys = {
			{ "<leader>ff", "<CMD>FzfLua files<CR>", desc = "[F]zf [F]iles" }, -- NOTE: keep for backwards compatibility <leader><space>
			{ "<leader><leader>", "<CMD>FzfLua files<CR>", desc = "[F]zf [F]iles" },
			-- { "<leader>fr", "<CMD>FzfLua oldfiles<CR>", desc = "[F]zf [R]ecent files" },
			{ "<leader>fg", "<CMD>FzfLua live_grep<CR>", desc = "[F]zf by [G]rep" }, -- NOTE: keep for backwards compatibility<leader>/
			{ "<leader>/", "<CMD>FzfLua live_grep<CR>", desc = "[F]zf by [G]rep" },
			{ "<leader>fw", "<CMD>FzfLua grep_cword<CR>", desc = "[F]zf [W]ord under cursor" },
			{ "<leader>fk", "<CMD>FzfLua keymaps<CR>", desc = "[F]zf [K]eymaps" },
			{ "<leader>fd", "<CMD>FzfLua diagnostic_documents<CR>", desc = "[F]zf [D]iagnostic document" },
			{ "<leader>fb", "<CMD>FzfLua buffers<CR>", desc = "[F]zf [B]uffers" }, -- NOTE: keep for backwards compatibility <leader><leader>
			{ "<leader><space>", "<CMD>FzfLua buffers<CR>", desc = "[F]zf [B]uffers" },
			{ "<leader>fc", "<CMD>FzfLua colorschemes<CR>", desc = "[F]zf [C]colorschemes" },
			{ "<leader>fr", "<CMD>FzfLua resume<CR>", desc = "[F]zf [R]esume" },
		},
		opts = function()
			local profile = require("fzf-lua.profiles.default-title")

			return vim.tbl_deep_extend("force", profile, {
				-- fzf_bin = "fzf-tmux",
				fzf_colors = true,
				fzf_opts = { ["--no-scrollbar"] = true },
				defaults = { formatter = "path.dirname_first" },
				previewers = {
					builtin = {
						extensions = {
							["png"] = { "viu", "-b" },
							["jpg"] = { "viu", "-b" },
							["jpeg"] = { "viu", "-b" },
							["gif"] = { "viu", "-b" },
							["webp"] = { "viu", "-b" },
						},
					},
				},
				files = {
					cwd_prompt = false,
					actions = {
						["alt-."] = { require("fzf-lua.actions").toggle_hidden },
					},
				},
				grep = {
					actions = {
						["alt-."] = { require("fzf-lua.actions").toggle_hidden },
					},
				},
				lsp = {
					symbols = {
						symbol_hl = function(s)
							return "TroubleIcon" .. s
						end,
						symbol_fmt = function(s)
							return s:lower() .. "\t"
						end,
						child_prefix = false,
					},
					code_actions = {
						previewer = "codeaction_native",
						preview_pager = vim.fn.executable("delta") == 1
								and "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS"
							or nil,
					},
				},
			})
		end,
	},

	------@override change existing keys to use FzfLua
	---{
	---	"rsmdt/quarry.nvim",
	---	opts = function()
	---		return {
	---			keys = {
	---				["gd"] = { "<CMD>FzfLua lsp_definitions<CR>", desc = "[G]oto [d]efinition" },
	---				["gr"] = { "<CMD>FzfLua lsp_references<CR>", desc = "[G]oto [r]eferences" },
	---				["gi"] = { "<CMD>FzfLua lsp_implementations<CR>", desc = "[G]oto [i]mplementation" },
	---				["gt"] = { "<CMD>FzfLua lsp_typedefs<CR>", desc = "[G]oto [t]ype definition" },
	---			},
	---		}
	---	end,
	---},
}
