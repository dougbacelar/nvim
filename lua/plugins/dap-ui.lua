-- Debugging Support
return {
  -- https://github.com/rcarriga/nvim-dap-ui
  'rcarriga/nvim-dap-ui',
  ft = 'java',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
    -- https://github.com/nvim-telescope/telescope-dap.nvim
    'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
    -- this seems to be required now https://github.com/rcarriga/nvim-dap-ui/pull/311/files
    'nvim-neotest/nvim-nio',
  },
  opts = {
    controls = {
      element = 'repl',
      enabled = false,
      icons = {
        disconnect = '',
        pause = '',
        play = '',
        run_last = '',
        step_back = '',
        step_into = '',
        step_out = '',
        step_over = '',
        terminate = '',
      },
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = 'single',
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
    force_buffers = true,
    icons = {
      collapsed = '',
      current_frame = '',
      expanded = '',
    },
    layouts = {
      {
        elements = {
          {
            id = 'scopes',
            size = 0.50,
          },
          {
            id = 'stacks',
            size = 0.30,
          },
          {
            id = 'watches',
            size = 0.10,
          },
          {
            id = 'breakpoints',
            size = 0.10,
          },
        },
        size = 40,
        position = 'left', -- Can be "left" or "right"
      },
      {
        elements = {
          'repl',
          'console',
        },
        size = 10,
        position = 'bottom', -- Can be "bottom" or "top"
      },
    },
    mappings = {
      edit = 'e',
      expand = { '<CR>', '<2-LeftMouse>' },
      open = 'o',
      remove = 'd',
      repl = 'r',
      toggle = 't',
    },
    render = {
      indent = 1,
      max_value_lines = 100,
    },
  },
  config = function(_, opts)
    local dap = require 'dap'
    require('dapui').setup(opts)

    dap.listeners.after.event_initialized['dapui_config'] = function()
      require('dapui').open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      -- require('dapui').close()
    end

    -- Add dap configurations based on your language/adapter settings
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- dap.configurations.xxxxxxxxxx = {
    --   {
    --   },
    -- }

    dap.configurations.java = {
      {
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach)',
        hostName = '127.0.0.1',
        port = 5005,
      },
    }


    vim.keymap.set('n', '<leader>bb', "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
    vim.keymap.set('n', '<leader>bc', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
    vim.keymap.set('n', '<leader>bl', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
    vim.keymap.set('n', '<leader>br', "<cmd>lua require'dap'.clear_breakpoints()<cr>")
    vim.keymap.set('n', '<leader>ba', '<cmd>Telescope dap list_breakpoints<cr>')
    vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<cr>")
    vim.keymap.set('n', '<leader>dj', "<cmd>lua require'dap'.step_over()<cr>")
    vim.keymap.set('n', '<leader>dk', "<cmd>lua require'dap'.step_into()<cr>")
    vim.keymap.set('n', '<leader>do', "<cmd>lua require'dap'.step_out()<cr>")
    vim.keymap.set('n', '<leader>dd', function()
      require('dap').disconnect()
      require('dapui').close()
    end)
    vim.keymap.set('n', '<leader>dt', function()
      require('dap').terminate()
      require('dapui').close()
    end)
    vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<cr>")
    vim.keymap.set('n', '<leader>dl', "<cmd>lua require'dap'.run_last()<cr>")
    vim.keymap.set('n', '<leader>di', function()
      require('dap.ui.widgets').hover()
    end)
    vim.keymap.set('n', '<leader>d?', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end)
    vim.keymap.set('n', '<leader>df', '<cmd>Telescope dap frames<cr>')
    vim.keymap.set('n', '<leader>dh', '<cmd>Telescope dap commands<cr>')
    vim.keymap.set('n', '<leader>de', function()
      require('telescope.builtin').diagnostics { default_text = ':E:' }
    end)
  end,
}
