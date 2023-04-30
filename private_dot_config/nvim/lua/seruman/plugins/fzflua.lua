return {
    {
        "ibhagwan/fzf-lua",
        -- dependencies = {
        --     "kyazdani42/nvim-web-devicons",
        -- },
        -- Load no matter what.
        lazy = false,
        config = function()
            local fzflua = require("fzf-lua")

            fzflua.setup({
                files = {
                    prompt = "Files> ",
                    -- Use FZF_DEFAULT_COMMAND to keep the default behavior.
                    cmd = vim.env.FZF_DEFAULT_COMMAND,
                },
                winopts = {
                    preview = {
                        layout = "vertical",
                        vertical = "up:60%",
                    }
                }
            })
            fzflua.register_ui_select()

            vim.keymap.set("n", "<leader>ff",
                function()
                    require("fzf-lua").files()
                end,
                { desc = "Files" }
            )
            vim.keymap.set("n", "<leader>fcf",
                function()
                    require("fzf-lua").files({
                        cwd = vim.fn.expand("%:p:h"),
                    })
                end,
                { desc = "Files in current buffer's directory" }
            )
            vim.keymap.set("n", "<leader>fg",
                function()
                    require("fzf-lua").git_files()
                end,
                { desc = "Git files" }
            )
            vim.keymap.set("n", "<leader>fb",
                function()
                    require("fzf-lua").buffers()
                end,
                { desc = "Buffers" }
            )
            vim.keymap.set("n", "<leader>frg",
                function()
                    require("fzf-lua").live_grep_native()
                end,
                { desc = "Live grep" }
            )
            vim.keymap.set("n", "<leader>fh/",
                function()
                    require("fzf-lua").search_history()
                end,
                { desc = "Search history" }
            )
            vim.keymap.set("n", "<leader>fh:",
                function()
                    require("fzf-lua").command_history()
                end,
                { desc = "Command history" }
            )
            vim.keymap.set("n", "<leader>fc",
                function()
                    require("fzf-lua").commands()
                end,
                { desc = "Commands" }
            )

            vim.keymap.set("i", "<c-x><c-l>a",
                function()
                    require("fzf-lua").complete_line()
                end,
                { desc = "Complete line (all buffers)" }
            )

            vim.keymap.set("i", "<c-x><c-l>b",
                function()
                    require("fzf-lua").complete_line()
                end,
                { desc = "Complete line (all buffers)" }
            )
        end
    },
}
