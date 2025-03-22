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
    -- 'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
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

    vim.keymap.set('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = 'Toggle Debug Breakpoint' })
    vim.keymap.set('n', '<leader>di', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", { desc = 'Debug If Condition' })
    vim.keymap.set('n', '<leader>dL', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", { desc = 'Debug Log Message' })
    vim.keymap.set('n', '<leader>dR', "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = 'Debug Reset Breakpoints' })
    vim.keymap.set('n', '<leader>dc', "<cmd>lua require'dap'.continue()<cr>", { desc = 'Debug Continue' })
    vim.keymap.set('n', '<leader>dj', "<cmd>lua require'dap'.step_over()<cr>", { desc = 'Debug Step Jover' })
    vim.keymap.set('n', '<leader>di', "<cmd>lua require'dap'.step_into()<cr>", { desc = 'Debug Into' })
    vim.keymap.set('n', '<leader>do', "<cmd>lua require'dap'.step_out()<cr>", { desc = 'Debug Out' })
    vim.keymap.set('n', '<leader>dd', function()
      require('dap').disconnect()
      require('dapui').close()
    end, { desc = 'Debug Disconnect' })
    vim.keymap.set('n', '<leader>dt', function()
      require('dap').terminate()
      require('dapui').close()
    end, { desc = 'Debug Terminate' })
    vim.keymap.set('n', '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<cr>", { desc = 'Debug Read Eval Print Loop' })
    vim.keymap.set('n', '<leader>d.', "<cmd>lua require'dap'.run_last()<cr>", { desc = 'Debug . (Last)' })
    vim.keymap.set('n', '<leader>dk', function()
      require('dap.ui.widgets').hover()
    end, { desc = 'Debug K hover' })
    vim.keymap.set('n', '<leader>ds', function()
      local widgets = require 'dap.ui.widgets'
      widgets.centered_float(widgets.scopes)
    end, { desc = 'Debug Scopes' })
    -- vim.keymap.set('n', '<leader>dl', '<cmd>Telescope dap list_breakpoints<cr>', { desc = 'Debug List Breakpoints' })
    -- vim.keymap.set('n', '<leader>df', '<cmd>Telescope dap frames<cr>', { desc = 'Debug Frames' })
    -- vim.keymap.set('n', '<leader>d:', '<cmd>Telescope dap commands<cr>', { desc = 'Debug : (Commands)' })
    vim.keymap.set('n', '<leader>dC', "<cmd>lua require'jdtls'.test_class()<cr>", { desc = 'Debug Class' })
    vim.keymap.set('n', '<leader>dm', "<cmd>lua require'jdtls'.test_nearest_method()<cr>", { desc = 'Debug Method' })
  end,
}
