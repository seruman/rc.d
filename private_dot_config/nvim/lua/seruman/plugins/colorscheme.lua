return {
    {
        "seruman/melange-nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.termguicolors = true
            vim.o.background = "light"
            vim.cmd("colorscheme melange")
        end,
    },
}
