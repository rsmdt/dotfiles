local root_pattern = require("lspconfig.util").root_pattern

local filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

return {
	"rudionrails/quarry.nvim",
	opts = {
		servers = {
			ts_ls = {
				tools = {
					"ts_ls",
					"eslint_d",
					"prettierd",
					-- lazy = true,
				},

				config = {
					-- root_dir = function(filename, bufnr)
					-- 	if root_pattern("deno.json", "deno.jsonc")(filename) then
					-- 		-- If this is a Deno project, don't start ts_ls.
					-- 		return nil
					-- 	end
					--
					-- 	-- Otherwise, use package.json as the root directory.
					-- 	return util.root_pattern("package.json")(filename)
					-- end,

					single_file_support = false,
					completions = { completeFunctionCalls = true },
					init_options = {
						preferences = {
							includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
							importModuleSpecifierPreference = "non-relative",
						},
					},
				},
			},

			-- eslint = {
			-- 	-- config = {
			-- 	-- 	on_attach = function(client, bufnr)
			-- 	-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	-- 			buffer = bufnr,
			-- 	-- 			command = "EslintFixAll",
			-- 	-- 		})
			-- 	-- 	end,
			-- 	-- },
			-- },

			-- denols = {
			-- 	tools = {
			-- 		"denols",
			-- 	},
			--
			-- 	config = {
			-- 		root_dir = root_pattern("deno.json", "deno.jsonc"),
			-- 	},
			-- },
		},
	},
}
