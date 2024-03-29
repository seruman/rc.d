return {
	{
		"seruman/melange-nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.o.termguicolors = true
			-- vim.o.background = "light"
			-- vim.cmd("colorscheme melange")

			local SearchHighlight = vim.api.nvim_get_hl(0, { name = "Search" })
			local TSLSPTypeNamespaceHighlight = vim.api.nvim_get_hl(0, { name = "@lsp.type.namespace" })
			vim.api.nvim_set_hl(0, "LspReferenceRead", {
				fg = SearchHighlight.fg,
				bg = TSLSPTypeNamespaceHighlight.fg,
				bold = true,
				undercurl = true,
			})
			vim.api.nvim_set_hl(0, "LspReferenceText", {
				fg = SearchHighlight.fg,
				bg = TSLSPTypeNamespaceHighlight.fg,
				bold = true,
				undercurl = true,
			})
			vim.api.nvim_set_hl(0, "LspReferenceWrite", {
				fg = SearchHighlight.fg,
				bg = TSLSPTypeNamespaceHighlight.fg,
				bold = true,
				undercurl = true,
			})
		end,
	},
	{
		"mcchrish/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			vim.o.termguicolors = true
			vim.o.background = "light"
			vim.g.seruzen = { darken_cursor_line = 5 }
			vim.cmd("colorscheme seruzen")
		end,
	},
}
