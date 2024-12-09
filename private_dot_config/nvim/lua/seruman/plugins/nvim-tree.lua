return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = {
			"NvimTreeToggle",
			"NvimTreeFindFile",
		},
		config = function()
			local nvimtree = require("nvim-tree")

			nvimtree.setup({
				view = {
					preserve_window_proportions = true,
					width = {
						min = 30,
						max = 120,
					},
				},
				renderer = {
					root_folder_label = false,
					group_empty = true,
					add_trailing = true,
					highlight_git = true,
					indent_markers = {
						-- Display indent markers when folders are open
						enable = true,
					},
					icons = {
						show = {
							git = false,
						},
					},
				},
				git = { enable = true },
				actions = {
					change_dir = { enable = false },
					expand_all = { exclude = { "node_modules", ".git", "vendor", "target" } },
					open_file = {
						resize_window = false, -- don't resize window when opening file
					},
				},
				filters = {
					custom = {
						"^.git$",
						".DS_Store",
						"node_modules",
						"vendor",
					},
				},
			})

			vim.keymap.set("n", "<leader>ntt", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
			vim.keymap.set("n", "<leader>ntff", "<Cmd>NvimTreeFindFile<CR>", { desc = "Find file in tree" })

			vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
				nested = false,
				callback = function(e)
					local tree = require("nvim-tree.api").tree

					-- Nothing to do if tree is not opened
					if not tree.is_visible() then
						return
					end

					-- How many focusable windows do we have? (excluding e.g. incline status window)
					local winCount = 0
					for _, winId in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(winId).focusable then
							winCount = winCount + 1
						end
					end

					-- We want to quit and only one window besides tree is left
					if e.event == "QuitPre" and winCount == 2 then
						vim.api.nvim_cmd({ cmd = "qall" }, {})
					end

					-- :bd was probably issued an only tree window is left
					-- Behave as if tree was closed (see `:h :bd`)
					if e.event == "BufEnter" and winCount == 1 then
						-- Required to avoid "Vim:E444: Cannot close last window"
						vim.defer_fn(function()
							-- close nvim-tree: will go to the last buffer used before closing
							tree.toggle({ find_file = true, focus = true })
							-- re-open nivm-tree
							tree.toggle({ find_file = true, focus = false })
						end, 10)
					end
				end,
			})
		end,
	},
}
