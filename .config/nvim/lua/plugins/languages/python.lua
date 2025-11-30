return {
	"rsmdt/quarry.nvim",
	opts = {
		servers = {
			pyright = {
				tools = {
					"pyright",
					"ruff",
					-- lazy = true,
				},

				config = {
					settings = {
						pyright = {
							autoImportCompletion = true,
						},
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								typeCheckingMode = "off",
							},
						},
					},
				},
			},
		},
	},
}
