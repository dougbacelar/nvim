-- set netrw to tree-style listing
vim.g.netrw_liststyle = 3

-- show the banner (top information in netrw)
vim.g.netrw_banner = 0

-- function to toggle netrw in a split and place the cursor on the current buffer file
_G.toggle_netrw_at_current_file = function()
  -- get the full path of the currently opened file in the buffer
  local current_file = vim.fn.expand '%:p'
  -- find if netrw window is already open (this is only needed if using Lexplore)
  local netrw_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf_ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'filetype')
    if buf_ft == 'netrw' then
      netrw_win = win
      break
    end
  end
  -- if netrw is already open, close it
  if netrw_win then
    vim.api.nvim_win_close(netrw_win, true)
    return
  end
  -- check if there is a currently opened file
  if current_file == '' then
    return
  end

  -- extract the directory and filename from the full path
  local current_dir = vim.fn.fnamemodify(current_file, ':h')
  local filename = vim.fn.fnamemodify(current_file, ':t')
  -- use Lexplore to open a left panel and navigate to the directory containing the file
  vim.cmd('Lexplore ' .. current_dir)
  -- set the width of the netrw window
  vim.cmd 'vertical resize 30'
  -- search for the filename
  vim.fn.search(filename)
end

-- function to open netrw and place the cursor on the current buffer file
_G.open_netrw_at_current_file = function()
  -- get the full path of the currently opened file in the buffer
  local current_file = vim.fn.expand '%:p'

  -- open netrw
  vim.cmd.Ex()

  if current_file == '' then
    return
  end

  -- check if there is a currently opened file
  -- extract only the filename from the full path
  local filename = vim.fn.fnamemodify(current_file, ':t')
  -- place the cursor on the current file by searching for the filename
  vim.fn.search(filename)
end

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

-- function to set icon for a single line
local function set_icon_for_line(ns_id, i, line)
  -- skip the netrw top banner (uncomment if banner is turned on)
  -- if i <= 7 then
  --   return
  -- end

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

-- open netrw at the current file's directory and place the cursor on the file
-- TODO: consider changing keymap to something easier to press
vim.api.nvim_set_keymap('n', '<leader>pv', ':lua _G.open_netrw_at_current_file()<CR>', { noremap = true, silent = true, desc = '[P]roject [V]iew' })

-- toggle netrw in a split at the current file's directory and place the cursor on the file
-- TODO: using these two hotkeys together causes errors
vim.api.nvim_set_keymap('n', '<leader>tpv', ':lua _G.toggle_netrw_at_current_file()<CR>', { noremap = true, silent = true, desc = '[T]oggle [P]roject [V]iew' })

-- copy the full file path to the clipboard
vim.keymap.set('n', 'yP', function()
  if vim.bo.filetype == 'netrw' then
    local filepath = vim.fn.expand '<cfile>'
    local fullpath = vim.fn.fnamemodify(filepath, ':p')
    vim.fn.setreg('+', fullpath)
  else
    -- also works with normal buffers
    vim.cmd 'let @+ = expand("%:p")'
  end
end, { noremap = true, silent = true })
