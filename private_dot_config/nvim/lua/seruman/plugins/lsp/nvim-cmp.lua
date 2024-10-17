return {
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		-- "hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					-- NOTE(selman): nvim-cmp requires a snippet engine to
					-- work, pass a no-op function to disable.
					--
					-- See; nvim-lspconfig, snippetSupport disabled in
					-- capabilities
					expand = function(_) end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-k>"] = cmp.mapping.confirm({ select = true }),
				}),
				view = {
					entries = {
						name = "custom",
						selection_order = "near_cursor",
					},
				},
				-- window = {
				--     completion = {
				--         winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
				--         col_offset = -3,
				--         side_padding = 0,
				--     },
				-- },
				formatting = {
					format = lspkind.cmp_format({
						with_text = true,
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- can also be a function to dynamically calculate max width such as
						-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						show_labelDetails = false, -- show labelDetails in menu. Disabled by default

						-- The function below will be called before any actual modifications from lspkind
						-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[LaTeX]",
							cody = "[cody]",
						},
					}),
				},
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Insert,
				},
				sources = cmp.config.sources({
					{ name = "cody" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			require("cmp").setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_document_symbol" },
				}, {
					{ name = "buffer" },
				}),
				view = {
					entries = { name = "wildmenu", separator = " | " },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				view = {
					entries = { name = "wildmenu", separator = " | " },
				},
			})
		end,
	},
}
