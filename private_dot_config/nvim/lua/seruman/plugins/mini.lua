return {
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>cts", "<cmd>lua MiniTrailspace.trim()<CR>", desc = "Trim trail spaces" },
		},
		opts = { only_in_normal_buffers = true },
	},
}
