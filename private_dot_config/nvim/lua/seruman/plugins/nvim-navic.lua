return {
	{
		"SmiteshP/nvim-navic",
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				highlight = true,
				lsp = {
					auto_attach = true,
				},
			})
		end,
	},
}
