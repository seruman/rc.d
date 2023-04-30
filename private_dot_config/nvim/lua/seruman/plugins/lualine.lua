return {
    {
        "nvim-lualine/lualine.nvim",
        -- dependencies = {
        --     "kyazdani42/nvim-web-devicons",
        -- },
        opts = function()
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


            return {
                options = {
                    -- TODO(selman): Melange support.
                    theme = "solarized_light",
                    icons_enabled = false,
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { { "mode", fmt = format_mode } },
                },
            }
        end
    },
}
