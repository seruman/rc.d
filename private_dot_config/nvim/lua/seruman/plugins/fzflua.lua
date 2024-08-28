return {
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"folke/trouble.nvim",
		},
		-- Load no matter what.
		lazy = false,
		config = function()
			local fzflua = require("fzf-lua")

			local quicfix_trouble = function(selected, opts)
				if #selected > 1 then
					-- code from `actions.file_sel_to_qf`
					local qf_list = {}
					for i = 1, #selected do
						local file = require("fzf-lua").path.entry_to_file(selected[i])
						local text = selected[i]:match(":%d+:%d?%d?%d?%d?:?(.*)$")
						table.insert(qf_list, {
							filename = file.path,
							lnum = file.line,
							col = file.col,
							text = text,
						})
					end
					-- this sets the quickfix list, you may or may not need it for 'trouble.nvim'
					vim.fn.setqflist(qf_list)
					-- call the command to open the 'trouble.nvim' interface
					require("trouble").toggle("quickfix")
				end
			end

			fzflua.setup({
				"default-title",
				hls = { title = "PMenuSel" },
				grep = { RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH },
				files = {
					prompt = "Files> ",
					-- Use FZF_DEFAULT_COMMAND to keep the default behavior.
					cmd = vim.env.FZF_DEFAULT_COMMAND,
					actions = {
						["ctrl-r"] = quicfix_trouble,
					},
				},
				winopts = {
					preview = {
						vertical = "up:60%",
						layout = "flex",
						wrap = "wrap",
						title = false,
						scrollbar = "float",
						delay = 50,
					},
					border = "single",
					backdrop = 97,
				},
				lsp = {
					code_actions = {
						prompt = "Code Actions> ",
						async_or_timeout = 5000,
						winopts = {
							height = 0.3,
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>ff", function()
				require("fzf-lua").files()
			end, { desc = "Files" })
			vim.keymap.set("n", "<leader>fcf", function()
				require("fzf-lua").files({
					cwd = vim.fn.expand("%:p:h"),
				})
			end, { desc = "Files in current buffer's directory" })
			vim.keymap.set("n", "<leader>fg", function()
				require("fzf-lua").git_files()
			end, { desc = "Git files" })
			vim.keymap.set("n", "<leader>fb", function()
				require("fzf-lua").buffers()
			end, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>frb", function()
				require("fzf-lua").lgrep_curbuf()
			end, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>frg", function()
				require("fzf-lua").live_grep_native()
			end, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>frr", function()
				require("fzf-lua").resume()
			end, { desc = "Resume last command/query" })
			vim.keymap.set("n", "<leader>fh/", function()
				require("fzf-lua").search_history()
			end, { desc = "Search history" })
			vim.keymap.set("n", "<leader>fh:", function()
				require("fzf-lua").command_history()
			end, { desc = "Command history" })
			vim.keymap.set("n", "<leader>fc", function()
				require("fzf-lua").commands()
			end, { desc = "Commands" })

			vim.keymap.set("i", "<c-x><c-l>a", function()
				require("fzf-lua").complete_line()
			end, { desc = "Complete line (all buffers)" })

			vim.keymap.set("i", "<c-x><c-l>b", function()
				require("fzf-lua").complete_line()
			end, { desc = "Complete line (all buffers)" })

			vim.keymap.set("n", "<leader>ft", function()
				local fzf = require("fzf-lua")
				fzf.grep({
					prompt = "TODO> ",
					search = [[TODO(\(.+?\))?:]],
					no_esc = true,
					no_header_i = true,
					no_header = true,
				})
			end, { desc = "Find TODOs" })

			vim.keymap.set("n", "<leader>fn", function()
				require("fzf-lua").grep({
					prompt = "NOTE> ",
					search = [[NOTE(\(.+?\))?:]],
					no_esc = true,
					no_header_i = true,
					no_header = true,
				})
			end, { desc = "Find NOTEs" })
		end,
	},
}
