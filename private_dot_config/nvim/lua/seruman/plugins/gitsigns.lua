return {
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- -- Navigation
				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next Hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Prev Hunk" })
				--
				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Hunk" })
				-- map("v", "<leader>hr", function()
				-- 	gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				-- end)
				-- map("n", "<leader>hS", gs.stage_buffer)
				-- map("n", "<leader>hu", gs.undo_stage_hunk)
				-- map("n", "<leader>hR", gs.reset_buffer)
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk" })
				-- map("n", "<leader>hb", function()
				-- 	gs.blame_line({ full = true })
				-- end)
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
				-- map("n", "<leader>hd", gs.diffthis)
				-- map("n", "<leader>hD", function()
				-- 	gs.diffthis("~")
				-- end)
				-- map("n", "<leader>td", gs.toggle_deleted)

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
}
