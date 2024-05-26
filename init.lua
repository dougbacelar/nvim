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
-- Auto Commands
----
-- setup auto save
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  callback = function(args)
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand '%' ~= '' and vim.bo.buftype == '' then
      -- only way to get format working with auto save is having it in the same autocmd, consider removing it later
      require('conform').format {
        bufnr = args.buf,
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      }
      -- write the file (:w)
      vim.api.nvim_command 'silent update'
    end
  end,
})

-- highlight when yanking (copying) text. Adjust `timeout` to change duration of highlight
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('doug-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

----
-- Plugins
----
--  To check the current status of your plugins, run
--    :Lazy
--  You can press `?` in this menu for help. Use `:q` to close the window
--  To update plugins, you can run
--    :Lazy update
require('lazy').setup {
  require 'plugins.web-devicons',
  require 'plugins.vim-sleuth',
  require 'plugins.which-key',
  require 'plugins.gitsigns',
  require 'plugins.treesitter-textobjects',
  require 'plugins.catppuccin',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp-config',
  require 'plugins.cmp',
  require 'plugins.conform',
  require 'plugins.mini-misc',
}

-- modules in core are not loaded by Lazy
require 'core.options'
-- cant load this with lazy, leaving it outside for now
require 'plugins.netrw-config'

-- see `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
