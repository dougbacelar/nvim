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

--  this function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('doug-lsp-attach', { clear = true }),
  callback = function(event)
    -- lsp

    -- jump to the definition of the word under your cursor. This is where a variable was first declared, or where a function is defined, etc.
    --  to jump back, press <C-T>, <C-O> or backticks ``
    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = 'LSP: [G]oto [D]efinition' })

    -- find references for the word under your cursor.
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = 'LSP: [G]oto [R]eferences' })

    --
    vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_incoming_calls, { desc = 'LSP: [G]oto [I]ncoming Calls' })

    --
    vim.keymap.set('n', 'gO', require('telescope.builtin').lsp_outgoing_calls, { desc = 'LSP: [G]oto [O]utgoing Calls' })

    -- jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation. Idk how this is different from lsp_incoming_calls
    vim.keymap.set('n', 'gP', require('telescope.builtin').lsp_implementations, { desc = 'LSP: [G]oto Im[P]lementation' })

    -- jump to the type of the word under your cursor. useful when you're not sure what type a variable is and you want to see
    vim.keymap.set('n', 'gy', require('telescope.builtin').lsp_type_definitions, { desc = 'LSP: T[y]pe Definition' })

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = 'LSP: [D]ocument [S]ymbols' })

    -- Fuzzy find all the symbols in your current workspace
    --  Similar to document symbols, except searches over your whole project.
    vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'LSP: [W]orkspace [S]ymbols' })

    -- Rename the variable under your cursor
    --  Most Language Servers support renaming across files, etc.
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP: [R]e[n]ame' })

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: [C]ode [A]ction' })

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
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
