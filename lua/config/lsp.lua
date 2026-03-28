-- language server protocol setup
require('fidget').setup()

--  this function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('doug-lsp-attach', { clear = true }),
  callback = function(event)
    -- highlights references of the word under your cursor when your cursor rests there for a little while.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      -- clear the highlights when the cursor is moved
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = event.buf })
  end,
})

-- Confirm with <CR> when popup is visible; otherwise insert a newline
vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })

-- Set global capabilities for all LSP servers
vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })

-- Enable LSP servers
-- Server-specific configurations are in lsp/<server_name>.lua
local servers = { 'basedpyright', 'gopls', 'html', 'lua_ls', 'sourcekit', 'ts_ls' }
for _, name in ipairs(servers) do
  vim.lsp.enable(name)
end
