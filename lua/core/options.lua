----
-- Options
----

-- decrease update time, I think default is 4 seconds. should make plugins respond quicker if they wait for update events
vim.o.updatetime = 250
-- decrease timeout for keybinds, should make shortcuts snappier but potentially harder to press. (also affects which-key plugin)
vim.o.timeoutlen = 300
-- save undo history on disk even after closing file.
vim.o.undofile = true
-- remove line numbers by default. Use :set number to manually turn it on and :set nonumber to manually turn it back off
vim.opt.number = false
-- tells nvim to use the "+" register. This will share the clipboard between nvim/MacOS
vim.opt.clipboard = 'unnamedplus'
-- indents wrapped lines so they are easier to read
vim.opt.breakindent = true
-- makes search case-insensitive when all letters are lower case. If at least a single letter is upper case, the search will become case-sensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- sets how neovim will display tabs, trailling spaces and non-breaking spaces in the editor. This helps identify wrong whitespaces inserted accidentally in a file
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- highlight current cursor line
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- set netrw to tree-style listing
vim.g.netrw_liststyle = 3

-- show the banner (top information in netrw)
vim.g.netrw_banner = 1
