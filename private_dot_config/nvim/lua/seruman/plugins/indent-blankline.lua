return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup {
                enabled = false,
                indent = {
                    -- highlight = 'IndentBlanklineChar',
                    -- char = "",
                },
                whitespace = {
                    -- highlight = 'IndentBlanklineSpaceChar',
                    remove_blankline_trail = false,
                },
                scope = { enabled = false },
            }
        end,
    },
}
