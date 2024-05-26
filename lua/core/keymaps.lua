----
-- Key maps
----

-- turn off search highlight
vim.keymap.set('n', '<esc>', '<cmd>noh<cr><esc>')

-- toggle 'number'
vim.keymap.set('n', '<leader>tn', ':set number!<CR>', { silent = true, noremap = true, desc = '[T]oggle [N]umber Lines' })

-- toggle 'relativenumber'
vim.keymap.set('n', '<leader>trn', ':set relativenumber!<CR>', { silent = true, noremap = true, desc = '[T]oggle [R]elative [N]umber Lines' })

-- yank file name of current buffer
vim.keymap.set('n', 'yN', ':let @+=expand("%:t")<CR>', { noremap = true, silent = true })
