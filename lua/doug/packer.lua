-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- fuzzy finding
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.4',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }

  -- color theme
  use { "catppuccin/nvim", as = "catppuccin" }

  -- git ui
  use('tpope/vim-fugitive')

  -- git browse to gitlab with :GBrowse
  use('shumphrey/fugitive-gitlab.vim')
  vim.g.fugitive_gitlab_domains = {'https://gitlab.test.com/'}

end)

