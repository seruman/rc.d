return {
	{
		"rafaelsq/nvim-goc.lua",
		dependencies = {},
		config = function()
			vim.opt.switchbuf = "useopen"

			local goc = require("nvim-goc")
			goc.setup({ verticalSplit = false }) -- default to horizontal

			vim.keymap.set("n", "<Leader>gcf", goc.Coverage, { silent = true }) -- run for the whole File
			vim.keymap.set("n", "<Leader>gct", goc.CoverageFunc, { silent = true }) -- run only for a specific Test unit
			vim.keymap.set("n", "<Leader>gcc", goc.ClearCoverage, { silent = true }) -- clear coverage highlights
		end,
	},
}
