----
-- Key maps
----

-- turn off search highlight
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>')

-- toggle 'number'
vim.keymap.set('n', '<leader>tn', ':set number!<CR>', { silent = true, noremap = true, desc = '[T]oggle [N]umber Lines' })
-- toggle 'relativenumber'
vim.keymap.set('n', '<leader>trn', ':set relativenumber!<CR>', { silent = true, noremap = true, desc = '[T]oggle [R]elative [N]umber Lines' })

-- yank file name or path of current buffer
vim.keymap.set('n', 'yN', ':let @+ = expand("%:t")<CR>', { noremap = true, silent = true, desc = '[Y]ank File [N]ame' })
vim.keymap.set('n', 'yP', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true, desc = '[Y]ank File [P]ath' })

-- Buffers
-- go to the previous buffer
vim.keymap.set('n', '<leader>pb', ':bprevious<CR>', { desc = '[P]revious [B]uffer' })
-- go to the next buffer
vim.keymap.set('n', '<leader>nb', ':bnext<CR>', { desc = '[N]ext [B]uffer' })
-- close the current buffer
vim.keymap.set('n', '<leader>db', ':bdelete<CR>', { desc = '[D]elete [B]uffer' })

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
