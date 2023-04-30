return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "j-hui/fidget.nvim",   config = true },
            { "ibhagwan/fzf-lua" },
        },
        config = function()
            local function setup_gopls()
                -- Format on save.
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = vim.api.nvim_create_augroup('GoFormatOnSave', { clear = true }),
                    pattern = '*.go',
                    callback = function()
                        -- Format already sorts imports.
                        vim.lsp.buf.format({ async = true })
                    end
                })

                local tags = "tags=" .. table.concat({
                    "integration",
                    "selman",
                    "tools",
                }, ",")

                return {
                    -- Build
                    env = { GOFLAGS = tags },
                    buildFlags = { tags },

                    -- Formatting
                    gofumpt = true,
                    ["local"] = table.concat({
                        "github.com/seruman",
                        vim.env.GOPLS_LOCAL,
                    }, ","),

                    -- Diagnostics
                    analyses = {
                        nilness = true,
                        shadow = true,
                        unusedparams = true,
                        unusedwrite = true,
                        unusedvariable = true,
                    },
                    staticcheck = true,

                    -- UI
                    -- Code Lenses
                    codelenses = {
                        generate = true,
                        test = true,
                        tidy = true,
                        vendor = true,
                    },
                    -- TODO(selman): Could not get this to work, how LSP
                    -- snippets work?
                    experimentalPostfixCompletions = true,
                    -- TODO(selman): Probably my colorscheme/LSP setup would
                    -- not handle this.
                    semanticTokens = true,
                }
            end

            local function setup_lua_ls()
                return {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    }
                }
            end

            local function setup_pylsp()
                return {
                    plugins = {
                        flake8 = { enabled = false },
                        pycodestyle = {
                            enabled = true,
                            ignore = { "E501", "E731", "W503", "E203" }
                        },
                        pylint = { enabled = false },
                        pylsp_mypy = {
                            enabled = true,
                            overrides = { "--ignore-missing-imports", true, "--disable-error-code",
                                "annotation-unchecked" }
                        },
                        -- TODO(selman): I do not remember which one of them
                        -- makes it work, got sick of dealing with it.
                        pylsp_black = { enabled = true, line_length = 120 },
                        black = { enabled = true, line_length = 120 },
                        isort = { enabled = true, profile = "black" },
                    }
                }
            end

            local function setup_default()
                return {}
            end

            local servers = {
                gopls = setup_gopls,
                pylsp = setup_pylsp,
                bashls = setup_default,
                lua_ls = setup_lua_ls,
                tsserver = setup_default,
                yamlls = setup_default,
                -- TODO(selman):
                -- pylsp
                -- jdtls
            }

            local capabilities = require("cmp_nvim_lsp").default_capabilities({
                -- Disable snippets, see nvim-cmp configuration.
                snippetSupport = false
            })

            local flags = { debounce_text_changes = 150 }

            local lspconfig = require("lspconfig")
            for server, setupfn in pairs(servers) do
                local settings = setupfn()

                lspconfig[server].setup({
                    capabilities = capabilities,
                    flags = flags,
                    settings = settings,
                })
            end


            -- Set mappings on LSP attach.
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                        vim.lsp.diagnostic.on_publish_diagnostics,
                        {
                            virtual_text = true,
                            signs = true,
                            update_in_insert = false,
                            underline = true,
                        }
                    )

                    local fzfopts = {
                        ignore_current_line = true,
                        jump_to_single_result = true
                    }

                    local function opts(o)
                        return vim.tbl_extend('keep', { buffer = ev.buf }, o)
                    end

                    -- TODO(selman): What a messy format.
                    vim.keymap.set(
                        'n', 'gD',
                        function() require("fzf-lua").lsp_declarations(fzfopts) end,
                        opts({ desc = "LSP declarations" })
                    )
                    vim.keymap.set(
                        'n', 'gd',
                        function() require("fzf-lua").lsp_definitions(fzfopts) end,
                        opts({ desc = "LSP definitions" })
                    )
                    vim.keymap.set(
                        'n', 'K',
                        vim.lsp.buf.hover,
                        opts({ desc = "LSP hover", })
                    )
                    vim.keymap.set(
                        'n', 'gi',
                        function() require("fzf-lua").lsp_implementations(fzfopts) end,
                        opts({ desc = "LSP implementations" })
                    )
                    -- TODO(selman): Does not work on Alacritty+tmux. Guessing
                    -- it is something to do with Alacritty
                    vim.keymap.set(
                        { 'n', 'i' },
                        '<C-k>',
                        vim.lsp.buf.signature_help,
                        opts({ desc = "LSP signature help", })
                    )
                    vim.keymap.set(
                        'n', '<space>rn',
                        vim.lsp.buf.rename,
                        opts({ desc = "LSP rename", })
                    )
                    vim.keymap.set(
                        { 'n', 'v' },
                        '<leader>ca',
                        vim.lsp.buf.code_action,
                        opts({ desc = "LSP code action" })
                    )
                    vim.keymap.set(
                        { 'n', 'v' },
                        '<leader>cl',
                        vim.lsp.codelens.run,
                        opts({ desc = "LSP code lens" })
                    )
                    vim.keymap.set(
                        'n', 'gr',
                        vim.lsp.buf.references,
                        opts({ desc = "LSP references" })
                    )
                    vim.keymap.set(
                        'n', '<space>f',
                        function()
                            vim.lsp.buf.format { async = true }
                        end,
                        opts({ desc = "LSP format" })
                    )
                    vim.keymap.set(
                        'n', '<leader>dd',
                        function()
                            require("fzf-lua").lsp_document_diagnostics(fzfopts)
                        end,
                        opts({ desc = "LSP diagnostics (document)" })
                    )
                    vim.keymap.set(
                        'n', '<leader>dw',
                        function()
                            require("fzf-lua").lsp_workspace_diagnostics(fzfopts)
                        end,
                        opts({ desc = "LSP diagnostics (workspace)" })
                    )
                    vim.keymap.set(
                        'n', '<leader>ic',
                        function()
                            require("fzf-lua").lsp_incoming_calls(fzfopts)
                        end,
                        opts({ desc = "LSP incoming calls" })
                    )
                    vim.keymap.set(
                        'n', '<leader>oc',
                        function()
                            require("fzf-lua").lsp_incoming_calls(fzfopts)
                        end,
                        opts({ desc = "LSP outgound calls" })
                    )
                    vim.keymap.set(
                        'n', '<leader>sd',
                        function()
                            require("fzf-lua").lsp_document_symbols(fzfopts)
                        end,
                        opts({ desc = "LSP symbols (document)" })
                    )
                    vim.keymap.set(
                        'n', '<leader>sw',
                        function()
                            require("fzf-lua").lsp_live_workspace_symbols(fzfopts)
                        end,
                        opts({ desc = "LSP symbold (workspace)" })
                    )
                    vim.keymap.set(
                        'n', '<leader>td',
                        function()
                            require("fzf-lua").lsp_typedefs(fzfopts)
                        end,
                        opts({ desc = "LSP typedefs" })
                    )
                    -- TODO(selman): jump to next/previous dignostic.
                end,
            })
        end
    }
}
