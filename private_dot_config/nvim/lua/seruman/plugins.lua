local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use("takac/vim-hardtime")

    -- Color
    use("savq/melange")
    --- Adds missing LSP colors
    use("folke/lsp-colors.nvim")

    -- Status line
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- LSP
    use("neovim/nvim-lspconfig")
    --- Completion
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    -- TODO(selman):
    use("folke/lsp-trouble.nvim")
    use("j-hui/fidget.nvim")
    use {
        'ojroques/nvim-lspfuzzy',
        requires = {
            { 'junegunn/fzf' },
            { 'junegunn/fzf.vim' }, -- to enable preview (optional)
        },
    }
    use("simrat39/symbols-outline.nvim")


    -- mini.nvim
    use { 'echasnovski/mini.align', branch = 'stable' }

    -- Language specific
    use { "github/copilot.vim", config = function()
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_set_keymap("i", "<C-T>", 'copilot#Accept("")', { expr = true })
        local sysname = vim.loop.os_uname().sysname
        if sysname == "Darwin" then
            vim.g.copilot_node_command = "node"
        end
    end
    }
    -- TODO(selman): make it not to colide with lsp
    -- Add mapping for GoFillStruct
    use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
    -- TODO(selman):
    -- elzr/vim-json
    -- plasticboy/vim-markdown
    -- jdtls
    --

    -- TreeSitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use("nvim-treesitter/nvim-treesitter-textobjects")

    -- FZF
    use({
        "junegunn/fzf",
        run = function()
            fn["fzf#install"](0)
        end,
    })
    use("junegunn/fzf.vim")

    use("lukas-reineke/indent-blankline.nvim")
    use("folke/todo-comments.nvim")

    -- Move around, break stuff
    use("easymotion/vim-easymotion")
    use("tpope/vim-commentary")
    use("AndrewRadev/splitjoin.vim")
    use("justinmk/vim-sneak")
    use("tpope/vim-surround")
    use("ryvnf/readline.vim")

    -- Align/Format text -not code specific-
    use("godlygeek/tabular")
    use("junegunn/vim-easy-align")


    use("tpope/vim-dispatch")
    -- TODO(selman): not setup
    use("folke/which-key.nvim")

    -- Git
    use({
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        -- tag = 'release' -- To use the latest release
    })

    -- NVIM
    use("svermeulen/vimpeccable")

    -- To be able to yank with OSC52 over SSH
    use("ojroques/vim-oscyank")

    use("rafcamlet/nvim-luapad")

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- TODO(selman):
-- for nvim-cmp
-- set completeopt=menu,menuone,noselect
