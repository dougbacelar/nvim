-- useful plugin to show you pending keybinds.
require('which-key').setup {
  delay = 250,
  spec = {
    { '<leader>f', group = 'Find' },
    { '<leader>s', group = 'Search' },
    { '<leader>g', group = 'Git' },
    { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
    { '<leader>t', group = 'Toggle' },
  },
}
