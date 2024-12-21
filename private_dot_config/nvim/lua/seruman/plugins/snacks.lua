return {
	{
		"folke/snacks.nvim",
		opts = {
			bigfile = {},
			quickfile = {},
			indent = { enabled = false },
		},
		config = function()
			vim.api.nvim_create_user_command("IndentEnable", "lua Snacks.indent.enable()", { nargs = 0 })
			vim.api.nvim_create_user_command("IndentDisable", "lua Snacks.indent.disable()", { nargs = 0 })
		end,
	},
}
