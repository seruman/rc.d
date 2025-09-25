vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = vim.fn.expand("~") .. "/.config/massren/temp/*",
	callback = function()
		vim.bo.filetype = "massren"
		vim.bo.commentstring = "// %s"

		vim.cmd([[
			syntax clear
			syntax match massrenComment "^\/\/.*$"
			highlight link massrenComment Comment
		]])
	end,
})
