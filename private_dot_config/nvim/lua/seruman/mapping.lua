local vimp = require('vimp')

-- TODO: this should not be where
-- and should not be a global.
function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
      print(name)
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  print("Config reloaded")
end

-- TODO: vimp??
vim.api.nvim_set_keymap('n', '<Leader>vs', '<Cmd>lua ReloadConfig()<CR>', { silent = true, noremap = true })
vim.cmd('command! ReloadConfig lua ReloadConfig()')


-- nnoremap <leader>nh <cmd>nohl<cr>
vimp.nnoremap('<leader>nh', '<cmd>nohl<cr>')

-- nnoremap <leader>w :w<CR>
vimp.nnoremap('<leader>w', ':w<cr>')

-- nnoremap <leader>q :q<CR>
vimp.nnoremap('<leader>q', ':q<cr>')

-- nnoremap <leader>cl :set cursorline!<CR>
vimp.nnoremap('<leader>cl', ':set cursorline!<cr>')


-- TODO(selman): Move plugin specifig mappings/setups/configs to its own file.
-- packer/install at;
--  - lua/seruman/plugins/init.lua -> require("seruman.plugins.init")
-- Plugin specific setups;
--  - lua/seruman/plugins/setup.lua -> require("seruman.plugins.setup")
--      - require("seruman/plugins/fzf") <-> Not sure if it works like this inside setup.lua

--[[
-- xmap ga <Plug>(EasyAlign)
-- let g:sneak#label = 1
-- 
-- imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
-- let g:copilot_no_tab_map = v:true

--]]

