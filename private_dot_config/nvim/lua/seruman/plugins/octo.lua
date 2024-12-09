return {
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("octo").setup({
				picker = "fzf-lua",
			})
		end,
		cmd = "Octo",
	},
}
