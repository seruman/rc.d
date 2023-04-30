return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- NOTE(selman): nvim-cmp requires a snippet engine to
                    -- work, pass a no-op function to disable.
                    --
                    -- See; nvim-lspconfig, snippetSupport disabled in
                    -- capabilities
                    expand = function(_)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm { select = true },
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                },
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "near_cursor",
                    },
                },

                formatting = {
                    format = function(entry, vim_item)
                        -- Source
                        vim_item.menu = ({
                            buffer = "[Buffer]",
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            nvim_lua = "[Lua]",
                            latex_symbols = "[LaTeX]",
                        })[entry.source.name]
                        return vim_item
                    end
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Insert,
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = "buffer" },
                    { name = "path" },
                },
            })

            require 'cmp'.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp_document_symbol' }
                }, {
                    { name = 'buffer' }
                }),
                view = {
                    entries = { name = 'wildmenu', separator = ' | ' }
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                view = {
                    entries = { name = 'wildmenu', separator = ' | ' }
                },
            })
        end
    },
}
