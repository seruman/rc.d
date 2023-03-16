local vimp = require('vimp')

vim.g.fzf_layout = { down = "40%" }


-- nnoremap <Leader>fcf       :Files %:p:h<CR>
-- TODO(selman): Lua function with FZF to wipeout buffers
-- nnoremap <leader>bd      :BD<CR>



-- FZF
local normal_mappings = {
    ['<leader>ff']  = ':Files<CR>',
    ['<leader>fgf'] = ':GFiles<CR>',
    ['<leader>fb']  = ':Buffers<CR>',
    ['<leader>frg'] = ':Rg<CR>',
    ['<leader>fw']  = ':Windows<CR>',
    ['<leader>fh']  = ':History<CR>',
    ['<leader>f/']  = ':History/<CR>',
    ['<leader>f:']  = ':History:<CR>',
    ['<leader>fc '] = ':Commands<CR>',
    ['<leader>fuc'] = ':Unicodemoji<CR>',
    ['<Leader>fcf'] = ':Files %:p:h<CR>',
}

for map, action in pairs(normal_mappings) do
    vimp.nnoremap(map, action)
end

-- Hide statusline, mode, ruler in when FZF is active
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'fzf',
    callback = function()
        local current_buffer = vim.api.nvim_get_current_buf()

        vim.o.laststatus = 0
        vim.o.showmode = false
        vim.o.ruler = false

        vim.api.nvim_create_autocmd('BufLeave', {
            buffer = current_buffer,
            callback = function()
                vim.o.laststatus = 2
                vim.o.showmode = true
                vim.o.ruler = true
            end
        })
    end
})
