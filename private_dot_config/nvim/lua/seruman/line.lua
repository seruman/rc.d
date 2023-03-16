local function strsplit(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function format_mode(mode)
    local parts = strsplit(mode, "-")
    local m     = ""
    for _, v in pairs(parts) do
        m = m .. v:sub(1, 1)
    end
    return m
end

require("lualine").setup({
    options = {
        icons_enabled = false,
        theme = "onelight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { { "mode", fmt = format_mode } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", symbols = { readonly = "[]" } } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
})
