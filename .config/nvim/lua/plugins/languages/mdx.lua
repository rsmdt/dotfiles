return {
	"rsmdt/quarry.nvim",
	opts = {
		servers = {
			-- @mdx-js/language-server (mason: mdx-analyzer). Attaches to the `mdx`
			-- filetype registered by mdx.nvim. The lspconfig default resolves the
			-- TypeScript SDK in before_init, so no manual tsdk/init_options needed.
			mdx_analyzer = {
				tools = {
					"mdx_analyzer",
				},
			},
		},
	},
}
