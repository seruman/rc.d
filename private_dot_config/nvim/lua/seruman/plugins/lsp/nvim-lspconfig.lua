return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            -- TODO(selman): Pin fidget.nvim as it's being rewritten.
            { "j-hui/fidget.nvim",   tag = 'legacy', config = true },
            { "ibhagwan/fzf-lua" },
        },
        config = function()
            local function setup_gopls()
                -- Format on save.
                -- TODO(selman): organizeImports breaks imports some how, could not figure out why.

                local function goimports()
                    -- NOTE(selman): Could not get imports to work with;
                    --     vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true, })
                    -- Causes dobule imports or write in the middle of existing text/import statement.
                    -- Request and apply code action manually;
                    -- copied from: https://github.com/golang/go/issues/57281
                    -- -not a related issue though-
                    local params = vim.lsp.util.make_range_params()
                    params.context = { only = { "source.organizeImports" } }

                    local response = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                    for _, r in pairs(response or {}) do
                        for _, action in pairs(r.result or {}) do
                            -- textDocument/codeAction can return either Command[] or CodeAction[]. If
                            -- it is a CodeAction, it can have either an edit, a command or both.
                            -- Edits should be executed first.
                            if action.edit then
                                vim.lsp.util.apply_workspace_edit(action.edit, "UTF-8")
                            end
                            if action.command then
                                -- If the response was a Command[], then the inner "command' is a
                                -- string, if the response was a CodeAction, then the inner command is a
                                -- Command.
                                local command = type(action.command) == "table" and action.command or action
                                vim.lsp.buf.execute_command(command)
                            end
                        end
                    end
                end

                -- START: SHAME
                -- TODO(selman): Have no idea if this is the way to do it.
                vim.api.nvim_create_autocmd('LspAttach', {
                    callback = function(args)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client == nil or client.name == nil or client.name ~= "gopls" then
                            return
                        end

                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = vim.api.nvim_create_augroup('GoFormatOnSave', { clear = true }),
                            pattern = '*.go',
                            callback = function()
                                goimports()
                                vim.lsp.buf.format({ async = false })
                            end
                        })
                    end
                })
                vim.api.nvim_create_autocmd('LspDetach', {
                    pattern = '*',
                    callback = function(args)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client == nil or client.name == nil or client.name ~= "gopls" then
                            return
                        end

                        -- vim.api.nvim_del_augroup_by_name('GoFormatOnSave')
                        pcall(vim.api.nvim_del_augroup, 'GoFormatOnSave')
                    end
                })
                -- END: SHAME

                local tags = "-tags=" .. table.concat({
                    "integration",
                    "selman",
                    "tools",
                }, ",")

                return {
                    settings = {
                        gopls = {
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
                                -- NOTE(selman): Tired of warnings for`if err := ...; err != nil`.
                                shadow = false,
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
                    }
                }
            end

            local function setup_lua_ls()
                -- TODO(selman): Does not recognize nvim stuff.
                return {
                    settings = {
                        Lua = {
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
                    }
                }
            end

            local function setup_pylsp()
                return {
                    settings = {
                        pylsp = {
                            plugins = {
                                flake8 = { enabled = false },
                                yapf = { enabled = false },
                                autopep8 = { enabled = false },
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
                                pylsp_black = { enabled = true, line_length = 120, skip_string_normalization = true },
                                black = { enabled = true, line_length = 120, skip_string_normalization = true },
                                rope_autoimport = { enabled = true },
                            }
                        }
                    }
                }
            end




            local function setup_rust_analyzer()
                local ok, rust_analyzer_bin = pcall(
                    vim.fn.system,
                    { 'rustup', 'which', 'rust-analyzer' }
                )
                if not ok then
                    rust_analyzer_bin = 'rust-analyzer'
                end

                rust_analyzer_bin = string.gsub(rust_analyzer_bin, "\n$", "")

                return {
                    cmd = { rust_analyzer_bin },
                }
            end


            local function setup_yamlls()
                return {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            schemaStore = {
                                enable = true
                            },
                        }
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
                jdtls = setup_default,
                tsserver = setup_default,
                yamlls = setup_yamlls,
                terraformls = setup_default,
                rust_analyzer = setup_rust_analyzer,
                zls = setup_default,
                clangd = setup_default,
            }

            local capabilities = require("cmp_nvim_lsp").default_capabilities({
                -- Disable snippets, see nvim-cmp configuration.
                snippetSupport = false
            })

            local flags = { debounce_text_changes = 150 }

            local lspconfig = require("lspconfig")
            for server, setupfn in pairs(servers) do
                local setupargs = setupfn()

                local _setup_args = vim.tbl_extend('force', {
                    capabilities = capabilities,
                    flags = flags,
                }, setupargs)

                lspconfig[server].setup(_setup_args)
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
                        function()
                            require("fzf-lua").lsp_references(fzfopts)
                        end,
                        opts({ desc = "LSP references" })
                    )
                    vim.keymap.set(
                        'n', '<space>f',
                        function()
                            vim.lsp.buf.format()
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

                    vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end,
                        opts({ desc = "LSP next diagnostic" }))
                    vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end,
                        opts({ desc = "LSP previous diagnostic" }))

                    -- restart LSP <space>lr
                    vim.keymap.set(
                        'n', '<space>lr',
                        function()
                            vim.cmd('LspRestart')
                        end,
                        opts({ desc = "LSP restart" })
                    )
                end,
            })
        end
    }
}
