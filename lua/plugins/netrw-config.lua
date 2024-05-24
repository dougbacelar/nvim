-- set netrw to tree-style listing
vim.g.netrw_liststyle = 3

-- show the banner (top information in netrw)
vim.g.netrw_banner = 1

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

-- function to set icon for a single line
local function set_icon_for_line(ns_id, i, line)
  -- skip the netrw top banner
  if i <= 7 then
    return
  end

  -- check if the line represents a folder by looking for a trailing '/'
  if line:match '/$' then
    return
  end

  -- find the position of the file name
  local file_start = line:find '[^%s|]'
  if not file_start then
    return
  end

  -- get the file extension
  local ext = vim.fn.fnamemodify(line, ':e')
  -- get the icon and its highlight group
  local icon, hl = require('nvim-web-devicons').get_icon(line, ext, { default = true })
  if not icon then
    return
  end

  -- set virtual text with the icon before the file name
  vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, file_start - 3, {
    virt_text = { { icon .. ' ', hl } },
    virt_text_pos = 'overlay',
  })
end

-- function to set up icons for netrw using virtual text
local function set_netrw_icons()
  -- clear existing virtual text
  local ns_id = vim.api.nvim_create_namespace 'netrw_icons'
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  -- get all lines in the buffer
  local lines = vim.fn.getline(1, '$')
  -- ensure lines is an array
  if type(lines) == 'string' then
    lines = { lines }
  end

  -- loop through each line
  for i, line in ipairs(lines) do
    set_icon_for_line(ns_id, i, line)
  end
end

-- autocommand to set icons when netrw is opened
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = set_netrw_icons,
})
