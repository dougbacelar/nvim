return {
  {
    'echasnovski/mini.misc',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mini.misc').setup()
      -- sets the workspace when you open a project file so file pickers work better
      MiniMisc.setup_auto_root()
    end,
  },
  {
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md
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
        if files.close() then
          return
        end
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        -- specify path so current opened file is focused when opening
        files.open(path)
        -- reveal current working directory (project root)
        files.reveal_cwd()
      end

      local files_group = vim.api.nvim_create_augroup('doug-mini-files', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        desc = '',
        group = files_group,
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- add an additional keymap to close the panel, this can be removed later. Note `q` and `-` will also close it.
          vim.keymap.set('n', '<Esc>', files.close, { buffer = buf_id, desc = 'Close file explorer' })

          -- can also use `l`, but I am used to <CR>
          vim.keymap.set('n', '<CR>', function()
            files.go_in { close_on_file = true }
          end, {
            buffer = buf_id,
            desc = 'Open file under cursor and closes explorer',
          })
        end,
      })
      -- TODO: to consider, make `-` go up one level to mimic netrw default behaviour (and Oil.nvim)
      vim.keymap.set('n', '-', minifiles_toggle, { desc = 'Open file explorer' })
    end,
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    version = '*',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
}
