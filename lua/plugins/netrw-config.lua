-- function to open netrw and place the cursor on the current buffer file
_G.open_netrw_at_current_file = function()
  -- get the full path of the currently opened file in the buffer
  local current_file = vim.fn.expand '%:p'
  -- open netrw
  vim.cmd.Ex()
  -- check if there is a currently opened file
  if current_file ~= '' then
    -- extract only the filename from the full path
    local filename = vim.fn.fnamemodify(current_file, ':t')
    -- place the cursor on the current file in netrw by searching for the filename
    vim.fn.search(filename)
  end
end

-- map <leader>pv to open netrw at the current file's directory and place the cursor on the file
vim.api.nvim_set_keymap('n', '<leader>pv', ':lua _G.open_netrw_at_current_file()<CR>', { noremap = true, silent = true, desc = '[P]roject [V]iew' })

-- function to move the cursor to the next folder in netrw (downward)
_G.move_cursor_to_next_folder = function()
  -- get the current line content
  local current_line = vim.fn.getline '.'
  -- if the current line is a folder, move to the next line to avoid getting stuck
  if current_line:match '/$' then
    vim.cmd 'normal! j'
  end
  -- search for the closest folder downwards
  local found = vim.fn.search('/$', 'n')
  if found ~= 0 then
    vim.api.nvim_win_set_cursor(0, { found, 0 })
  end
end

-- function to move the cursor to the previous folder in netrw (upward)
_G.move_cursor_to_prev_folder = function()
  -- search for the closest folder upwards
  local found = vim.fn.search('/$', 'bn')
  if found ~= 0 then
    vim.api.nvim_win_set_cursor(0, { found, 0 })
  end
end

-- set key mappings only for netrw
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    -- map l to move cursor to the next folder in netrw
    vim.api.nvim_buf_set_keymap(0, 'n', 'l', ':lua _G.move_cursor_to_next_folder()<CR>', { noremap = true, silent = true })
    -- map h to move cursor to the previous folder in netrw
    vim.api.nvim_buf_set_keymap(0, 'n', 'h', ':lua _G.move_cursor_to_prev_folder()<CR>', { noremap = true, silent = true })
  end,
})
