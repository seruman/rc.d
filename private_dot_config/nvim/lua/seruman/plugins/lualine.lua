return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"SmiteshP/nvim-navic",
			"kyazdani42/nvim-web-devicons",
		},
		opts = function()
			local function strsplit(s, delimiter)
				local result = {}
				for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
					table.insert(result, match)
				end
				return result
			end

			local function format_mode(mode)
				local parts = strsplit(mode, "-")
				local m = ""
				for _, v in pairs(parts) do
					m = m .. v:sub(1, 1)
				end
				return m
			end

			return {
				options = {
					-- theme = "seruzen",
					icons_enabled = false,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = {
						{ "mode", fmt = format_mode },
					},
					lualine_c = {
						{ "navic" },
					},
				},
				tabline = {
					lualine_a = {
						{
							"tabs",
							max_length = vim.o.columns,
							mode = 2,
							use_mode_colors = true,
						},
					},
				},
			}
		end,
	},
}
