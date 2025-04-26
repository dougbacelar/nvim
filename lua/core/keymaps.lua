----
-- Key maps
----

-- turn off search highlight
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>')

-- toggle 'number'
vim.keymap.set('n', '<leader>tn', ':set number!<CR>', { silent = true, noremap = true, desc = 'Toggle Number Lines' })
-- toggle 'relativenumber'
vim.keymap.set('n', '<leader>trn', ':set relativenumber!<CR>', { silent = true, noremap = true, desc = 'Toggle Relative Number Lines' })
-- toggle diagnostics on/off, helpful for noisy LSPs
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle Diagnostics' })

-- yank file name or path of current buffer
vim.keymap.set('n', 'yN', ':let @+ = expand("%:t")<CR>', { noremap = true, silent = true, desc = 'Yank File Name' })
vim.keymap.set('n', 'yP', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true, desc = 'Yank File Path' })

-- buffers
-- close the current buffer
vim.keymap.set('n', '<leader>db', ':bdelete<CR>', { desc = 'Delete Buffer' })

-- windows
-- easier focus navigation
vim.keymap.set('n', '<c-j>', '<c-w><c-j>', { desc = 'Focus Below Window' })
vim.keymap.set('n', '<c-k>', '<c-w><c-k>', { desc = 'Focus Above Window' })
vim.keymap.set('n', '<c-l>', '<c-w><c-l>', { desc = 'Focus Right Window' })
vim.keymap.set('n', '<c-h>', '<c-w><c-h>', { desc = 'Focus Left Window' })

-- control window width
vim.keymap.set('n', '<c-,>', '<c-w>5<', { desc = 'Decrese Window Width' })
vim.keymap.set('n', '<c-.>', '<c-w>5>', { desc = 'Increase Window Width' })
-- TODO: control window height
-- vim.keymap.set("n", "<M-t>", "<C-W>+")
-- vim.keymap.set("n", "<M-s>", "<C-W>-")

-- move selected text to blackhole register when paste on top of it
vim.keymap.set('x', 'p', '"_dP', { silent = true })
