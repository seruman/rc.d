return {
	{
		"SmiteshP/nvim-navic",
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				icongs = {},
				highlight = true,
				lsp = {
					auto_attach = true,
				},
			})
		end,
	},
}
