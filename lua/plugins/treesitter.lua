-- AST, syntax highlighting and stuff
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false, -- main branch does not support lazy-loading
  build = ':TSUpdate',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    -- Install parsers (runs asynchronously, no-op if already installed)
    require('nvim-treesitter').install {
      'bash',
      'c',
      'html',
      'lua',
      'markdown',
      'vim',
      'vimdoc',
      'query',
      'javascript',
      'typescript',
      'java',
      'swift',
    }

    -- Enable treesitter highlighting for all filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        -- Only enable if parser is available
        pcall(vim.treesitter.start, buf)
      end,
    })

    -- Note: Incremental selection was removed in the main branch rewrite
    -- You can use textobjects (am, im, etc.) for smart selections instead
    -- This will be available in v0.12: https://neovim.io/doc/user/lsp.html#v_an
  end,
}
