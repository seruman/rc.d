require("fidget").setup {}
require("lspfuzzy").setup {}
require("symbols-outline").setup {
    highlight_hovered_item = false,
}

-- START nvim-cmp
local cmp = require("cmp")

cmp.setup({
    enabled = true,
    snippet = {
        -- NOTE(selman): `cmp` requires a snippet engine, but I do not want to
        -- use snippets, Just to make it happy passing a a dummy one. Snippets
        -- are disabled with an override setting below;
        -- `... .default_capabilities()`
        expand = function(_)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
    },
        {
            { name = "buffer" },
        }
    ),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    -- completion = { autocomplete = false },
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    -- completion = { autocomplete = false },
    sources = {
        { name = "cmdline" },
        { name = "path" },
    }
})

-- TODO(selman): add LSP bindings, gd, gi etc.
local __capabilities = require("cmp_nvim_lsp").default_capabilities({
    -- I do not use snippets, disable. See `cmp.setup` above.
    snippetSupport = false
})
-- END nvim-cmp



-- Define keybindings on 'on_attach'
local __on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<space>sig', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
    buf_set_keymap("n", "<space>s", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            underline = true,
        }
    )
end


local lspconfig = require("lspconfig")
-- START: Servers
local settings = {
    gopls = {
        env = { GOFLAGS = "-tags=integration,selman,tools" },
        buildFlags = { "-tags=integration,selman,tools" },
        analyses = {
            unusedparams = true,
        },
        ["formatting.gofumpt"] = true,
        staticcheck = true,
    },
    pylsp = {
        -- formatCommand = {"black"},
        pylsp = {
            plugins = {
                pylint = { enabled = true },
                flakes = { enabled = false },
                pycodestyle = { enabled = true, ignore = { "E501", "E731" } },
                black = { enabled = true, line_length = 120 },
                isort = { enabled = true },
                -- TODO(selman): ruff
            },
        },
    },
    -- TODO(selman): use lua_ls
    -- sumneko_lua = {
    --     Lua = {
    --         runtime = {
    --             version = 'LuaJIT',
    --             path = { "lua/?.lua", "lua/?/init.lua", table.unpack(vim.split(package.path, ';')) },
    --         },
    --         diagnostics = {
    --             globals = { 'vim' },
    --         },
    --         workspace = {
    --             -- Make the server aware of Neovim runtime files
    --             library = vim.api.nvim_get_runtime_file("", true),
    --         },
    --         telemetry = {
    --             enable = false,
    --         },
    --     },
    -- },
    bashls = {},
    clangd = {},
    tsserver = {},
}

local __flags = { debounce_text_changes = 150 }
for server, config in pairs(settings) do
    lspconfig[server].setup({
        on_attach = __on_attach,
        capabilities = __capabilities,
        flags = __flags,
        settings = config,
    })
end

-- END: Servers
