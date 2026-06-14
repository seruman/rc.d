return {
	{
		"ghostty",
		dir = vim.env.GHOSTTY_RESOURCES_DIR,
		enabled = function()
			local ghostty_resources_dir = vim.env.GHOSTTY_RESOURCES_DIR
			local ghostty_plugin_dir = ghostty_resources_dir and (ghostty_resources_dir .. "/../nvim/site") or nil

			return ghostty_resources_dir ~= nil
				and vim.fn.isdirectory(ghostty_resources_dir) == 1
				and vim.fn.isdirectory(ghostty_plugin_dir) == 1
		end,
		lazy = true,
		ft = { "ghostty" },
	},
}
