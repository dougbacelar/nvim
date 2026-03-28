vim.pack.add({
  -- colorscheme: must load first so it's available on first render
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  -- no-config plugins
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/tpope/vim-sleuth' },
  { src = 'https://github.com/mfussenegger/nvim-jdtls' },
  -- immediate setup
  { src = 'https://github.com/j-hui/fidget.nvim' },
  { src = 'https://github.com/folke/snacks.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/echasnovski/mini.files' },
  -- deferred (BufRead)
  { src = 'https://github.com/stevearc/conform.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/echasnovski/mini.misc' },
  -- deferred (FileType lua)
  { src = 'https://github.com/folke/lazydev.nvim' },
  -- deferred (vim.schedule)
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/echasnovski/mini.ai' },
  { src = 'https://github.com/echasnovski/mini.surround' },
  { src = 'https://github.com/folke/which-key.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
})

-- :TSUpdate after nvim-treesitter is installed/updated (replaces lazy's `build = ':TSUpdate'`)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      vim.schedule(function() vim.cmd 'TSUpdate' end)
    end
  end,
})

-- Immediate setup

-- catppuccin (inline — short config)
require('catppuccin').setup {
  flavour = 'mocha',
  transparent_background = false,
  color_overrides = { mocha = { base = '#000000', mantle = '#000000' } },
}
vim.cmd.colorscheme 'catppuccin-mocha'

-- fidget + LSP
require 'plugins.lsp'

-- snacks
require 'plugins.snacks'

-- treesitter
require 'plugins.treesitter'

-- mini.files
require('plugins.mini').setup_files()

-- FileType lua → lazydev
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  once = true,
  callback = function()
    require('lazydev').setup()
  end,
})

-- BufReadPost/BufNewFile → conform, gitsigns, mini.misc
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
  once = true,
  callback = function()
    require 'plugins.conform'
    require 'plugins.gitsigns'
    require('plugins.mini').setup_misc()
  end,
})

-- VeryLazy equivalent → vim.schedule
vim.schedule(function()
  require 'plugins.lualine'
  require('plugins.mini').setup_ai()
  require('plugins.mini').setup_surround()
  require 'plugins.which-key'
  require 'plugins.treesitter-textobjects'
end)
