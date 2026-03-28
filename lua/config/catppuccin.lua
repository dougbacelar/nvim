require('catppuccin').setup {
  flavour = 'mocha',
  transparent_background = false,
  color_overrides = { mocha = { base = '#000000', mantle = '#000000' } },
}
vim.cmd.colorscheme 'catppuccin-mocha'
