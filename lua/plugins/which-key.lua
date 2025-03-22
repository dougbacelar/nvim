-- useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 250,
    spec = {
      { '<leader>c', group = 'Code', mode = { 'n', 'v' } },
      { '<leader>d', group = 'Document' },
      { '<leader>f', group = 'Find' },
      { '<leader>s', group = 'Search' },
      { '<leader>g', group = 'Git' },
      { '<leader>h', group = 'Git Hunk', mode = { 'n', 'v' } },
      { '<leader>r', group = 'Rename' },
      { '<leader>t', group = 'Toggle' },
      { '<leader>w', group = 'Workspace' }, -- TODO: add workspace keymaps
    },
  },
}
