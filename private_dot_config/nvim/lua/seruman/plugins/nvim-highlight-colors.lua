return {
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
			render = "virtual",
		},
		config = function()
			require("nvim-highlight-colors").setup({})
			-- require("nvim-highlight-colors").turnOff()
		end,
	},
}
