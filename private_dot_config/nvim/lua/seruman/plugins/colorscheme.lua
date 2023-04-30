return {
    {
        "savq/melange",
        -- TODO(selman): For some reason latest version does not work. Check if it
        -- is to do with terminal colors or tmux.
        commit = "4a9858e",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = "light"
            vim.cmd("colorscheme melange")
        end,
    },
}
