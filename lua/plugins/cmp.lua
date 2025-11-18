-- autocompletion
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'

    cmp.setup {
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- for an understanding of why these mappings were read `:help ins-completion`
      mapping = cmp.mapping.preset.insert {
        -- select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- accept ([y]es) the completion.
        --  this will auto-import if your LSP supports it.
        --  this will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<CR>'] = cmp.mapping.confirm { select = true },

        -- manually trigger a completion from nvim-cmp.
        --  menerally not needed as nvim-cmp will display completions whenever they are available.
        ['<C-Space>'] = cmp.mapping.complete {},
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
      },
    }
  end,
}
