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
