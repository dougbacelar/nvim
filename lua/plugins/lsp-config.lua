-- language server protocol stuff
return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
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
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Set global capabilities for all LSP servers
      vim.lsp.config('*', { capabilities = capabilities })

      -- Enable LSP servers
      -- Server-specific configurations are in lsp/<server_name>.lua
      -- These files override/extend the defaults from nvim-lspconfig
      local servers = {
        'basedpyright',
        'gopls',
        'html',
        'lua_ls',
        'ts_ls',
      }

      for _, server_name in ipairs(servers) do
        vim.lsp.enable(server_name)
      end
    end,
  },
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {},
  },
}
