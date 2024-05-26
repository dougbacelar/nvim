-- setup auto-workspace and restore cursor on file open
return {
  'echasnovski/mini.misc',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('mini.misc').setup()
    -- sets the workspace when you open a project file so telescope works better
    MiniMisc.setup_auto_root()

    -- restore the cursor upon reopening file!
    MiniMisc.setup_restore_cursor()
  end,
}
