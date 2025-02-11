----
-- Auto Commands
----
-- setup auto save
local autosave_group = vim.api.nvim_create_augroup('doug-autosave', { clear = true })
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  desc = 'auto save file on buffer leave or focus lost',
  group = autosave_group,
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
local yank_group = vim.api.nvim_create_augroup('doug-highlight-yank', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight when yanking (copying) text',
  group = yank_group,
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

-- code folding
-- update folding settings on buffer enter or when an lsp attaches
local folding_group = vim.api.nvim_create_augroup('doug-folding', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'LspAttach' }, {
  desc = 'set folding based on LSP if available and fallback to TreeSitter otherwise',
  group = folding_group,
  callback = function()
    -- TODO: Un-comment this when LSP folding reaches stable release! https://github.com/neovim/neovim/blob/a9cdf76e3a142c78b2b5da58c428e15e31cb0a15/runtime/lua/vim/lsp/_folding_range.lua
    -- local buf = vim.api.nvim_get_current_buf()
    -- local lsp_clients = vim.lsp.get_clients { bufnr = buf }

    -- check for lsp folding provider and return early if found
    -- for _, client in pairs(lsp_clients) do
    --   if client.server_capabilities.foldingRangeProvider then
    --     vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    --     vim.notify('using lsp folding for buffer ' .. buf)
    --     return
    --   end
    -- end

    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  desc = 'save folds when leaving a buffer',
  group = folding_group,
  pattern = '?*',
  callback = function()
    vim.cmd.mkview {}
  end,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'restore folds when re-entering a buffer',
  group = folding_group,
  pattern = '?*',
  callback = function()
    vim.schedule(function()
      -- delay loadview slightly to avoid conflicts with above folding autocmd
      vim.cmd.loadview { mods = { emsg_silent = true } }
    end)
  end,
})
