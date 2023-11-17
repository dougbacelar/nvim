-- decrease update time, I think default is 4 seconds. should make plugins respond quicker
vim.o.updatetime = 250
-- decrease timeout for keybinds, should make shortcuts snappier but potentially harder to press.
vim.o.timeoutlen = 400

-- save undo history on disk even after closing file.
vim.o.undofile = true

require("doug.remap")

