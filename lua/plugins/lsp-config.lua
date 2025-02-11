-- language server protocol stuff
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    -- useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function()
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
        vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, { desc = 'LSP: [G]oto [I]mplementation' })

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
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- but for many setups, the LSP (`ts_ls`) will work just fine
      ts_ls = {},
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
    }

    for server_name, opts in pairs(servers) do
      -- this handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for tsserver)
      opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
      require('lspconfig')[server_name].setup(opts)
    end
  end,
}
