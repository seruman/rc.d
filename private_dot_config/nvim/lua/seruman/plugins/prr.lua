return {
	{
		"danobi/prr",
		event = "VeryLazy",
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/vim")
		end,
	},
}
