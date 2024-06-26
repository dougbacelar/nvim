-- bootstrap lazy.nvim to manage plugin dependencies
-- See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- make sure to set mapleader before lazy.nvim so the mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- initialize plugins under plugins/ folder
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
require 'core.keymaps'
