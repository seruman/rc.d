local tscfg = require('nvim-treesitter.configs')

tscfg.setup{
    ensure_installed = "all",
    ignore_install = {
        "javascript",
    },
    highlight = {
        enable = true
    },
}

