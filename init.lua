-- make sure to set mapleader before lazy.nvim so the mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

----
-- Bootstrap plugin manager
----
-- setup lazy.nvim to manage plugin dependencies
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

----
-- Key maps
----

-- turn off search highlight
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>')

-- toggle 'number'
vim.keymap.set('n', '<leader>tn', ':set number!<CR>', { silent = true, noremap = true, desc = '[T]oggle [N]umber Lines' })

-- toggle 'relativenumber'
vim.keymap.set('n', '<leader>trn', ':set relativenumber!<CR>', { silent = true, noremap = true, desc = '[T]oggle [R]elative [N]umber Lines' })

-- yank file name of current buffer
vim.keymap.set('n', 'yN', ':let @+=expand("%:t")<CR>', { noremap = true, silent = true })

----
-- Plugins
----
--  To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--  To update plugins, you can run
--    :Lazy update
require('lazy').setup('plugins', {
  checker = {
    enabled = false, -- disable automatic update checks
    notify = false, -- disable notifications when updates are available
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugin changes are made
  },
})

-- modules in core are not loaded by Lazy
require 'core.options'
require 'core.netrw-config'
require 'core.autocmds'

-- see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
