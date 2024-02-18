return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "SmiteshP/nvim-navic",
            "kyazdani42/nvim-web-devicons",
        },
        opts = function()
            local function theme_melange()
                -- NOTE(selman): Kinda ripped from;
                -- https://github.com/nvim-lualine/lualine.nvim/wiki/Writing-a-theme
                local bg = vim.opt.background:get()
                local palette = require('melange/palettes/' .. bg)

                local a = palette.a -- Grays
                local b = palette.b -- Bright foreground colors
                local c = palette.c -- Foreground colors
                local d = palette.d -- Background colors


                return {

                    normal = {
                        a = { bg = a.com, fg = a.bg },
                        b = { bg = a.bg, fg = a.com },
                        c = { bg = a.float, fg = a.com },
                    },
                    insert = {
                        a = { bg = c.green, fg = a.bg },
                        b = { bg = a.bg, fg = c.green },
                        c = { bg = a.float, fg = c.green },
                    },
                    command = {
                        a = { bg = c.yellow, fg = a.bg },
                        b = { bg = a.bg, fg = c.yellow },
                        c = { bg = a.float, fg = c.yellow },
                    },
                    visual = {
                        a = { bg = c.magenta, fg = a.bg },
                        b = { bg = a.bg, fg = c.magenta },
                        c = { bg = a.float, fg = c.magenta },
                    },
                    replace = {
                        a = { bg = c.green, fg = a.bg },
                        b = { bg = a.bg, fg = c.green },
                        c = { bg = a.float, fg = c.green },
                    },
                    terminal = {
                        a = { bg = c.yellow, fg = a.bg },
                        b = { bg = a.bg, fg = c.yellow },
                        c = { bg = a.float, fg = c.yellow },
                    },
                    inactive = {
                        a = { bg = a.com, fg = a.bg },
                        b = { bg = a.bg, fg = a.com, gui = 'bold' },
                        c = { bg = a.float, fg = a.com },
                    },
                }
            end

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


            local navic = require("nvim-navic")
            navic.setup({
                icongs = {},
                highlight = true,
                lsp = {
                    auto_attach = true,
                },
            })
            return {
                options = {
                    -- TODO(selman): Melange support.
                    -- theme = "solarized_light",
                    -- theme = theme_melange(),
                    icons_enabled = false,
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = {
                        { "mode", fmt = format_mode },
                    },
                    lualine_c = {
                        {
                            function()
                                return navic.get_location()
                            end,
                            cond = function()
                                return navic.is_available()
                            end
                        },
                    }
                },
            }
        end
    },
}
