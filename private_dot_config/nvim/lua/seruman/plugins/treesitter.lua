return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/playground",
			"vrischmann/tree-sitter-templ",
			{
				"bezhermoso/tree-sitter-ghostty",
				build = "make nvim_install",
			},
		},
		config = function()
			local languages = {
				"c",
				"go",
				"gomod",
				"gowork",
				"lua",
				"vim",
				"bash",
				"typescript",
				"tsx",
				"javascript",
				"json",
				"comment",
				"css",
				"diff",
				"dockerfile",
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"html",
				"ini",
				"make",
				"python",
				"query",
				"sql",
				"terraform",
				"toml",
				"yaml",
				"zig",
				"http",
				"markdown",
				"markdown_inline",
				"templ",
				"java",
				"groovy",
			}

			local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
			parser_configs.just = {
				install_info = {
					url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
					files = { "src/parser.c", "src/scanner.c" },
					branch = "main",
				},
				maintainers = { "@IndianBoy42" },
			}

			parser_configs.dotenv = {
				install_info = {
					url = "https://github.com/pnx/tree-sitter-dotenv",
					branch = "main",
					files = { "src/parser.c", "src/scanner.c" },
				},
				filetype = "dotenv",
			}

			parser_configs.txtar = {
				install_info = {
					url = "https://github.com/FollowTheProcess/tree-sitter-txtar",
					branch = "main",
					files = { "src/parser.c" },
				},
				filetype = "txtar",
			}

			-- TODO
			vim.filetype.add({
				pattern = {
					[".env.*"] = "dotenv",
				},
			})

			vim.filetype.add({
				extension = {
					txtar = "txtar",
				},
			})

			require("nvim-treesitter.configs").setup({
				ensure_installed = languages,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = { enable = true },

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>", -- maps in normal mode to init the node/scope selection with enter
						node_incremental = "<CR>", -- increment to the upper named parent
						node_decremental = "<bs>", -- decrement to the previous node
						scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["iB"] = "@block.inner",
							["aB"] = "@block.outer",
							["aT"] = "@structtag.outer",
							-- NOTE(selman): collides with `at` for HTML tags.
							["at"] = "@go.subtest_call.outer",
							["atn"] = "@go.subtest_call.name.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]]"] = "@function.outer",
							["]t"] = "@go.subtest_call.outer",
						},
						goto_next_end = {
							["]["] = "@function.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
							["[t"] = "@go.subtest_call.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},

				playground = {
					enable = true,
				},
			})
		end,
	},
}
