-- decrease update time, I think default is 4 seconds. should make plugins respond quicker
vim.o.updatetime = 250
-- decrease timeout for keybinds, should make shortcuts snappier but potentially harder to press.
vim.o.timeoutlen = 400

-- save undo history on disk even after closing file.
vim.o.undofile = true

require("doug.remap")

-- setup auto save
vim.api.nvim_create_autocmd({ "BugLeave", "FocusLost" }, {
	callback = function()
		if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.api.nvim_command('silent update')
		end
	end,
})
