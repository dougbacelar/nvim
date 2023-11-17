require('mini.comment').setup()
require('mini.misc').setup()

-- sets the workspace when you open a project file so telescope works better
MiniMisc.setup_auto_root()

-- seems to restore the vertical position of the cursor but not horizontal (good enough)
MiniMisc.setup_restore_cursor()
