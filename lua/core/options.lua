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
-- experiment with relative numbers on by default
vim.opt.relativenumber = true
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
vim.opt.listchars = { tab = '  ', trail = '»', nbsp = '␣' }
-- highlight current cursor line
vim.opt.cursorline = true
-- minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- prevent text from flickering by keeping sign column always on (git signs, diagnostics, etc)
vim.opt.signcolumn = 'yes'

-- disable showing mode in the command line, as lualine will display it
vim.o.showmode = false

-- indentation rules, mostly used for new files where indentation cannot be inferred
-- set tab width
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- use spaces instead of tabs
vim.opt.expandtab = true

-- expands all folds by default
vim.opt.foldlevelstart = 99
-- ensures folds are saved in views autocmds
vim.opt.viewoptions = 'folds,cursor'

-- diagnostic options
vim.diagnostic.config { jump = { float = true } }
