return {
	{
		"github/copilot.vim",
		init = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
		end,
		config = function()
			vim.keymap.set("i", "<C-T>", 'copilot#Accept("<CR>")', {
				silent = true,
				expr = true,
				script = true,
				replace_keycodes = false,
				desc = "Copilot accept suggestion",
			})

			vim.keymap.set("i", "<C-C><C-]>", "copilot#Next()", {
				silent = true,
				expr = true,
				script = true,
				replace_keycodes = false,
				desc = "Copilot next suggestion",
			})

			vim.keymap.set("i", "<C-C><C-[>", "copilot#Previous()", {
				silent = true,
				expr = true,
				replace_keycodes = false,
				desc = "Copilot previous suggestion",
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
