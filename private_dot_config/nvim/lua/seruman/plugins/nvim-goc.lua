return {
	{
		"rafaelsq/nvim-goc.lua",
		dependencies = {},
		config = function()
			local goc = require("nvim-goc")
			goc.setup({ verticalSplit = false })

			vim.keymap.set("n", "<Leader>gcf", goc.Coverage, { silent = true, desc = "Go coverage (file)" })
			vim.keymap.set("n", "<Leader>gct", goc.CoverageFunc, { silent = true, desc = "Go coverage (test)" })
			vim.keymap.set("n", "<Leader>gcc", goc.ClearCoverage, { silent = true, desc = "Go coverage clear" })
		end,
	},
}
