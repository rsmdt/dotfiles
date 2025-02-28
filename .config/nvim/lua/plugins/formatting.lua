local format = function(opts)
	-- local buf = (opts or {}).buf or vim.api.nvim_get_current_buf()
	local conform = require("conform")
	local formatter_names = vim.tbl_map(function(formatter)
		return formatter.name
	end, conform.list_formatters_to_run(buf))

	-- Run formatters
	if #formatter_names > 0 then
		vim.notify("Formatting with " .. table.concat(formatter_names, ", "), vim.log.levels.INFO)

		conform.format({
			log_level = vim.log.levels.DEBUG,
			timeout_ms = 3000,
			async = false, -- nope, want to wait until finished
			quiet = false, -- need to know when things don't work
			lsp_format = "fallback",
			-- stop_after_first = true, -- only run the first available formatter in the list
		})
	end
end

return {
	"stevearc/conform.nvim",
	event = { "VeryLazy" },
	-- cmd = { "ConformInfo" }, -- "Format"
	keys = {
		{ "<leader>p", format, desc = "Format code [p]retty" },
	},
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			javascript = { "eslint", "prettierd", "prettier" },
			typescript = { "eslint", "prettierd", "prettier" },
			javascriptreact = { "eslint", "prettierd", "prettier" },
			typescriptreact = { "eslint", "prettierd", "prettier" },
			-- markdown = { "prettier" },
			yaml = { "prettierd", "prettier" },
			json = { "jq", "prettierd", "prettier" },
			sql = { "sqlfluff" }, -- { "sql-formatter", "sqlfmt", "sqlfluff" },
			python = { "isort", "black" },
			-- ["*"] = { "trim_whitespace" },
		},
		formatters = {
			sqlfluff = {
				command = "sqlfluff",
				args = { "fix", "-f", "-n", "-" },
				stdin = true,
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		-- vim.api.nvim_create_user_command("Format", format, { desc = "Format code" })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("_format", { clear = true }),
			callback = function(event)
				format({ buf = event.buf })
			end,
		})
	end,
}
