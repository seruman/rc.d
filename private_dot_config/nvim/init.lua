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
vim.o.cursorline = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "<c-l>", "<cmd>set cursorline!<CR>", { desc = "Toggle cursorline" })
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Move to next search match and center screen" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Move to previous search match and center screen" })
vim.keymap.set('n', '*', '*N', { desc = "Highlight without jumping forward" })
vim.keymap.set("t", "<leader><esc>", "<c-\\><c-n>", { desc = "Switch to normal mode in terminal buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<A-j>", "<Cmd>resize -2<CR>", { desc = "Resize split down" })
vim.keymap.set("n", "<A-k>", "<Cmd>resize +2<CR>", { desc = "Resize split up" })
vim.keymap.set("n", "<A-l>", "<Cmd>vertical resize -2<CR>", { desc = "Resize split right" })
vim.keymap.set("n", "<A-h>", "<Cmd>vertical resize +2<CR>", { desc = "Resize split left" })
vim.keymap.set("n", "gs", "<Cmd>vertical wincmd f<CR>", { desc = "Open file under cursor in vertical split" })

local yank_current_filepath = function()
    local fpath = vim.fn.expand('%');
    vim.fn.setreg('+', fpath);
end
vim.keymap.set("n", "<leader><C-g>p", yank_current_filepath, { desc = "Yank current file path to unnamed register" })


vim.cmd("inoreabbrev TODO TODO(selman):")
vim.cmd("inoreabbrev NOTE NOTE(selman):")

-- augroup CursorLine
--     au!
--     au VimEnter * setlocal cursorline
--     au WinEnter * setlocal cursorline
--     au BufWinEnter * setlocal cursorline
--     au WinLeave * setlocal nocursorline
-- augroup END
local AugroupCursorLine = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
    group = AugroupCursorLine,
    pattern= '*',
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd('WinEnter', {
    group = AugroupCursorLine,
    pattern= '*',
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    group = AugroupCursorLine,
    pattern= '*',
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

vim.api.nvim_create_autocmd('WinLeave', {
    group = AugroupCursorLine,
    pattern= '*',
    callback = function()
        vim.opt_local.cursorline = false
    end,
})
