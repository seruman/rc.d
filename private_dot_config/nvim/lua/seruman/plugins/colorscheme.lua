return {
	{
		"mcchrish/zenbones.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.o.background = "light"
			vim.g.seruzen = { darken_cursor_line = 5 }
			vim.cmd("colorscheme seruzen")
		end,
	},
}
