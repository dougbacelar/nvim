-- setup auto-workspace and restore cursor on file open
return {
  'echasnovski/mini.misc',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('mini.misc').setup()
    -- sets the workspace when you open a project file so file pickers work better
    MiniMisc.setup_auto_root()
  end,
}
