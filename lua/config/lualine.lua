-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
require('lualine').setup {
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diagnostics' },
    lualine_c = {
      'buffers',
      {
        function()
          return vim.bo.eol == false and '[noeol]' or ''
        end,
        color = { fg = 'red' },
      },
    },
    lualine_x = {},
    lualine_y = { 'diff' },
    lualine_z = { 'progress', 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
}
