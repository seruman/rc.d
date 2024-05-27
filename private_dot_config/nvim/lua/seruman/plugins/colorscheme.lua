return {
	{
		"mcchrish/zenbones.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			vim.o.termguicolors = true
			vim.o.background = "light"
			vim.g.seruzen = { darken_cursor_line = 5 }
			vim.cmd("colorscheme seruzen")
		end,
	},
}
