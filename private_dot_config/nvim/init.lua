--TODO(selman): Could not find a better name
require("seruman.bootstrap")
require("seruman.plugins")
require("seruman.fzf")
require("seruman.lsp")
require("seruman.ts")
-- TODO: use custom-made statusline
-- or use lightline
require("seruman.line")
require("seruman.git")
require("seruman.mapping")
require("seruman.abbrevations")
require("seruman.mini")
require("seruman.trouble")





vim.cmd("syntax on")
vim.o.hidden = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.number = true
vim.o.backspace = "indent,eol,start"
vim.o.showtabline = 2
vim.o.encoding = "utf-8"
vim.o.laststatus = 2
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.clipboard="unnamed"
vim.o.signcolumn="yes"


-- Disable vim-go's completion
vim.g.go_code_completion_enabled = 0


-- Disable indent-blanklines
vim.g.indent_blankline_enabled = false

-- TODO: termguicolors tmux thingy




vim.o.background="light"
vim.cmd("colorscheme melange")

-- TODO: python3 host prog


-- TODO: could be moved to its own file.
-- Hardtime
local hardtime_config = {
    hardtime_default_on = 1,
    hardtime_allow_different_key=1,
    hardtime_snowmsg=1,
    list_of_normal_keys = {},
    list_of_visual_keys = {},
    list_of_insert_keys = {},
    list_of_disabled_keys = {"<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"},
}
for k, v in pairs(hardtime_config) do
    vim.g[k] = v
end



