-- Set up plugin mananager; lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        spec = {
            { import = "seruman/plugins" },
            { import = "seruman/plugins.lsp" },
        },
        change_detection = {
            enabled = false,
            notify = false,
        },
    }
)


vim.cmd("syntax on")
vim.o.termguicolors = true
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
vim.o.clipboard = "unnamed"
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.switchbuf = table.concat({ "useopen", "usetab", "newtab" }, ",")

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<c-l>", "<cmd>set cursorline!<CR>", { desc = "Toggle cursorline" })
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Move to next search match and center screen" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Move to previous search match and center screen" })
vim.keymap.set('n', '*', '*N', { desc = "Highlight without jumping forward" })


vim.cmd("inoreabbrev TODO TODO(selman):")
vim.cmd("inoreabbrev NOTE NOTE(selman):")


-- TODO(selman): GoFillStruct
-- vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
