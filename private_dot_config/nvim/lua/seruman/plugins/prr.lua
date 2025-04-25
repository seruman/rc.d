return {
	{
		"danobi/prr",
		config = function(plugin)
			vim.opt.rtp:append(plugin.dir .. "/vim")
		end,
	},
}
