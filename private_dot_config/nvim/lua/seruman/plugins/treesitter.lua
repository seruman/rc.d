return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            local languages = {
                "c",
                "go",
                "gomod",
                "gowork",
                "lua",
                "vim",
                "bash",
                "typescript",
                "tsx",
                "javascript",
                "json",
                "comment",
                "css",
                "diff",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "html",
                "ini",
                "make",
                "python",
                "query",
                "sql",
                "terraform",
                "toml",
                "yaml"
            }

            require('nvim-treesitter.configs').setup({
                ensure_installed = languages,

                highlight = {
                    enable = true,
                    -- Disable highlights for large files
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",     -- maps in normal mode to init the node/scope selection with enter
                        node_incremental = "<CR>",   -- increment to the upper named parent
                        node_decremental = "<bs>",   -- decrement to the previous node
                        scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
                    },
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ["iB"] = "@block.inner",
                            ["aB"] = "@block.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            [']]'] = '@function.outer',
                        },
                        goto_next_end = {
                            [']['] = '@function.outer',
                        },
                        goto_previous_start = {
                            ['[['] = '@function.outer',
                        },
                        goto_previous_end = {
                            ['[]'] = '@function.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>a'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>A'] = '@parameter.inner',
                        },
                    },
                },
            })
        end,
    },
}
