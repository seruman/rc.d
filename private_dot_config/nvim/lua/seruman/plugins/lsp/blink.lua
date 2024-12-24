return {
	{
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp",
		optional = true,
		enabled = false,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"saghen/blink.compat",
				-- optional = true, -- make optional so it's only enabled if any extras need it
				opts = {
					impersonate_nvim_cmp = true,
				},
				version = "*",
			},
			{ "sourcegraph/sg.nvim" },
		},

		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<C-k>"] = { "select_and_accept" },
				["<C-K>"] = { "select_and_accept" },
				["<C-y>"] = { "select_and_accept" },

				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				-- ["<Tab>"] = { "snippet_forward", "fallback" },
				-- ["<S-Tab>"] = { "snippet_backward", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "buffer", "cody" },
				-- cmdline = {},
				providers = {
					cody = {
						name = "cody",
						score_offset = 100,
						async = true,
						module = "blink.compat.source",
					},
				},
			},
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
					},
				},
				accept = {
					auto_brackets = { enabled = false },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
			},
		},
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
	},
}
