-- language server protocol stuff
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
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

      --  can add override configuration in the following tables. Available keys are:
      --  - cmd: Override the default command used to start the server
      --  - filetypes: Override the default list of associated filetypes for the server
      --  - capabilities: Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings: Override the default settings passed when initializing the server.
      --        for example, to see the options for `lua_ls`, go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- skip setting up java lsp(jdtls) here to avoid having two processes attached
        basedpyright = {
          settings = {
            basedpyright = {
              -- typeCheckingMode = 'all',
              -- typeCheckingMode = 'recommended',
              -- typeCheckingMode = 'strict',
              -- typeCheckingMode = 'standard',
              typeCheckingMode = 'basic',
              -- typeCheckingMode = 'off',
            },
          },
        },
        gopls = {},
        html = {},
        kotlin_language_server = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        ts_ls = {},
      }

      for server_name, opts in pairs(servers) do
        -- this handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
        require('lspconfig')[server_name].setup(opts)
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
