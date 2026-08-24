-- Formatting is gated by `vim.g.disable_autoformat` (all buffers).
-- `vim.b.disable_autoformat` overrides the global for a single buffer when set,
-- so `:FormatEnable!` can re-enable one buffer while formatting is globally off.
local is_disabled = function(buf)
	local buf_local = vim.b[buf].disable_autoformat
	if buf_local ~= nil then
		return buf_local
	end
	return vim.g.disable_autoformat or false
end

local format = function(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()

	if is_disabled(buf) then
		-- Only speak up when the user asked for formatting; stay quiet on every write.
		if not opts.silent then
			vim.notify("Formatting is disabled (:FormatEnable to re-enable)", vim.log.levels.WARN)
		end
		return
	end

	local conform = require("conform")
	local formatter_names = vim.tbl_map(function(formatter)
		return formatter.name
	end, conform.list_formatters_to_run(buf))

	-- Run formatters
	if #formatter_names > 0 then
		vim.notify("Formatting with " .. table.concat(formatter_names, ", "), vim.log.levels.INFO)

		conform.format({
			bufnr = buf, -- format the buffer we listed formatters for, not just the current one
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
			html = { "prettier" },
			css = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			json = { "prettier" },
			sql = { "prettier", "sqlfluff" }, -- { "sql-formatter", "sqlfmt", "sqlfluff" },
			python = { "ruff" },
			["*"] = { "trim_whitespace" },
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
				format({ buf = event.buf, silent = true })
			end,
		})

		-- Bang (!) scopes the change to the current buffer, otherwise it is global.
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
			vim.notify("Formatting disabled" .. (args.bang and " for this buffer" or ""), vim.log.levels.INFO)
		end, { bang = true, desc = "Disable formatting (! = current buffer only)" })

		vim.api.nvim_create_user_command("FormatEnable", function(args)
			if args.bang then
				vim.b.disable_autoformat = false
			else
				vim.g.disable_autoformat = false
				vim.b.disable_autoformat = nil -- drop any buffer-local override
			end
			vim.notify("Formatting enabled" .. (args.bang and " for this buffer" or ""), vim.log.levels.INFO)
		end, { bang = true, desc = "Enable formatting (! = current buffer only)" })

		vim.api.nvim_create_user_command("FormatToggle", function(args)
			local disabled = is_disabled(vim.api.nvim_get_current_buf())
			if args.bang then
				vim.b.disable_autoformat = not disabled
			else
				vim.g.disable_autoformat = not disabled
				vim.b.disable_autoformat = nil
			end
			vim.notify(
				"Formatting " .. (disabled and "enabled" or "disabled") .. (args.bang and " for this buffer" or ""),
				vim.log.levels.INFO
			)
		end, { bang = true, desc = "Toggle formatting (! = current buffer only)" })
	end,
}
