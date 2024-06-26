-- setup lsp formatters
return {
  'stevearc/conform.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local conform = require 'conform'
    conform.setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        -- conform will run multiple formatters sequentially
        python = { 'isort', 'black' },
        -- use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' } },
        typescript = { { 'prettierd', 'prettier' } },
        javascriptreact = { { 'prettierd', 'prettier' } },
        typescriptreact = { { 'prettierd', 'prettier' } },
        css = { { 'prettierd', 'prettier' } },
        html = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        yaml = { { 'prettierd', 'prettier' } },
        markdown = { { 'prettierd', 'prettier' } },
        graphql = { { 'prettierd', 'prettier' } },
      },
      -- format on save is not working due to auto save, moved format code to auto-save autocmd
      -- fomart_on_save = { lsp_fallback = true, async = false, timeout_ms = 500 },
    }

    -- keep this keymap as a fallback for now just in case the autocmd doesn't work
    vim.keymap.set({ 'n', 'v' }, '<leader>l', function()
      conform.format { async = false }
    end, { desc = '[L]int' })
  end,
}
