-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md
return {
  'echasnovski/mini.files',
  version = '*',
  config = function()
    local files = require 'mini.files'

    files.setup {
      options = {
        -- use netrw as default for now
        use_as_default_explorer = false,
      },
    }
    local minifiles_toggle = function()
      if not files.close() then
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        -- specify path so current opened file is focused when opening
        files.open(path)
        -- reveal current working directory (project root)
        files.reveal_cwd()

        local buf_id = vim.api.nvim_get_current_buf()
        -- add an additional keymap to close the panel, this can be removed later. Note `q` and `-` will also close it.
        vim.keymap.set('n', '<Esc>', files.close, {
          buffer = buf_id,
          silent = true,
          desc = 'Close file explorer',
        })
        -- can also use `l`, but I am used to <CR>
        vim.keymap.set('n', '<CR>', function()
          files.go_in { close_on_file = true }
        end, {
          buffer = buf_id,
          silent = true,
          desc = 'Open file under cursor and closes explorer',
        })
      end
    end
    -- TODO: to consider, make `-` go up one level to mimic netrw default behaviour (and Oil.nvim)
    vim.keymap.set('n', '-', minifiles_toggle, { desc = 'Open file explorer' })
  end,
}

-- example of making buffer-specific mappings, use this instead if the above becomes unwieldy
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(args)
--     local buf_id = args.data.buf_id
--     vim.keymap.set('n', '<Esc>', function()
--       require('mini.files').close()
--     end, { buffer = buf_id, silent = true, desc = 'close mini.files' })
--   end,
-- })
