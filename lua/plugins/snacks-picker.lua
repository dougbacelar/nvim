return {
  -- filter further by file type with `foo -- -t=lua`.
  -- This only works on live grep, for other pickers use `foo file:lua$` instead
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    explorer = {
      replace_netrw = false,
    },
    picker = {
      ---@class snacks.picker.matcher.Config
      matcher = {
        -- the bonusses below, possibly require string concatenation and path normalization,
        -- so this can have a performance impact for large lists and increase memory usage
        cwd_bonus = true, -- give bonus for matching files in the cwd
        frecency = true, -- frecency bonus
        history_bonus = false, -- give more weight to chronological order
      },
      ---@class snacks.picker.formatters.Config
      formatters = {
        file = {
          filename_first = false, -- display filename before the file path
          truncate = 40, -- truncate the file path to (roughly) this length
          git_status_hl = true, -- use the git status highlight group for the filename
        },
      },

      win = {
        -- input window
        input = {
          keys = {
            ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
            ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
            ['<c-j>'] = { 'focus_list', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'focus_preview', mode = { 'i', 'n' } },
            ['<c-u>'] = 'preview_scroll_up',
            ['<c-d>'] = 'preview_scroll_down',
            ['<c-b>'] = 'list_scroll_up',
            ['<c-f>'] = 'list_scroll_down',
          },
        },
        -- result list window
        list = {
          keys = {
            ['<a-m>'] = 'toggle_maximize',
            ['<a-w>'] = 'cycle_win',
            ['<c-k>'] = 'focus_input',
            ['<c-l>'] = 'focus_preview',
            ['<c-u>'] = 'preview_scroll_up',
            ['<c-d>'] = 'preview_scroll_down',
            ['<c-b>'] = 'list_scroll_up',
            ['<c-f>'] = 'list_scroll_down',
          },
        },
        -- preview window
        preview = {
          keys = {
            ['i'] = 'focus_input',
            ['<a-w>'] = 'cycle_win',
            ['<c-h>'] = 'focus_input',
          },
        },
      },
    },
  },
  debug = {
    scores = true, -- show scores in the list
    leaks = true, -- show when pickers don't get garbage collected
    explorer = true, -- show explorer debug info
    files = true, -- show file debug info
    grep = true, -- show file debug info
    proc = true, -- show proc debug info
    extmarks = true, -- show extmarks errors
  },
  config = function(_, opts)
    local Snacks = require 'snacks'
    Snacks.setup(opts)
    -- manually setup
    vim.keymap.set('n', '<leader>fh', Snacks.picker.help, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', Snacks.picker.help, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>fF', function()
      Snacks.picker.files { hidden = true, ignored = true } -- TODO: add keymap for toggling ignored/hidden
    end, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>ff', Snacks.picker.git_files, { desc = '[F]ind Git [F]iles' }) -- consider changing to files if really fast
    vim.keymap.set('n', '<leader>fgf', Snacks.picker.git_files, { desc = '[F]ind [G]it [F]iles' })
    vim.keymap.set('n', '<leader>fw', Snacks.picker.grep_word, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fl', Snacks.picker.grep, { desc = '[F]ind [L]ive Grep' })
    vim.keymap.set('n', '<leader>/', Snacks.picker.grep, { desc = '[F]ind [L]ive Grep' })
    vim.keymap.set('n', '<leader>fd', Snacks.picker.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>f.', Snacks.picker.resume, { desc = '[F]ind Resume prev. picker ("." for repeat)' })
    vim.keymap.set('n', '<leader>fr', Snacks.picker.recent, { desc = '[F]ind [R]ecent Files' })
    vim.keymap.set('n', '<leader>fj', Snacks.picker.jumps, { desc = '[F]ind [J]ump List' })
    vim.keymap.set('n', '<leader>fgc', Snacks.picker.git_log, { desc = '[F]ind [G]it [C]ommits' })
    vim.keymap.set('n', '<leader>fgb', Snacks.picker.git_log_file, { desc = '[F]ind [G]it [B]uffer Commits' })
    vim.keymap.set('n', '<leader>fgB', Snacks.picker.git_branches, { desc = '[F]ind [G]it [B]ranches' })
    vim.keymap.set('n', '<leader>fb', Snacks.picker.buffers, { desc = '[F]ind [B]uffers' })
    vim.keymap.set('n', '<leader>fs', Snacks.picker.buffers, { desc = '[F]ind [S]mart' })
    vim.keymap.set('n', '<leader><leader>', Snacks.picker.smart, { desc = '[ ] Find Smart' })
    vim.keymap.set('n', '<leader>:', Snacks.picker.command_history, { desc = 'Find commands' })
    vim.keymap.set('n', '<leader>fn', Snacks.picker.notifications, { desc = '[F]ind [N]otifications' })
    vim.keymap.set('n', '<leader>e', function()
      Snacks.explorer()
    end, { desc = 'File Explorer' })
    -- vim.keymap.set('n', '<leader>`', Snacks.explorer, { desc = 'File Explorer' })
    vim.keymap.set('n', '<leader>fc', function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [C]onfig files' })
    vim.keymap.set('n', '<leader>fp', function()
      Snacks.picker.projects { dev = { '~/dev', '~/.config', '~/indeed' } }
    end, { desc = 'Projects' })

    -- some defaults that might be useful
    -- git
    vim.keymap.set('n', '<leader>gb', Snacks.picker.git_branches, { desc = 'Git Branches' })
    vim.keymap.set('n', '<leader>gl', Snacks.picker.git_log, { desc = 'Git Log' })
    vim.keymap.set('n', '<leader>gL', Snacks.picker.git_log_line, { desc = 'Git Log Line' })
    vim.keymap.set('n', '<leader>gs', Snacks.picker.git_status, { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>gS', Snacks.picker.git_stash, { desc = 'Git Stash' })
    vim.keymap.set('n', '<leader>gd', Snacks.picker.git_diff, { desc = 'Git Diff (Hunks)' })
    vim.keymap.set('n', '<leader>gf', Snacks.picker.git_log_file, { desc = 'Git Log File' })

    -- grep
    vim.keymap.set('n', '<leader>sb', Snacks.picker.lines, { desc = 'Buffer Lines' })
    vim.keymap.set('n', '<leader>sB', Snacks.picker.grep_buffers, { desc = 'Grep Open Buffers' })
    vim.keymap.set('n', '<leader>sg', Snacks.picker.grep, { desc = 'Grep' })
    vim.keymap.set({ 'n', 'x' }, '<leader>sw', Snacks.picker.grep_word, { desc = 'Visual selection or word' })

    -- search
    vim.keymap.set('n', '<leader>s"', Snacks.picker.registers, { desc = 'Registers' })
    vim.keymap.set('n', '<leader>s/', Snacks.picker.search_history, { desc = 'Search History' })
    vim.keymap.set('n', '<leader>sc', Snacks.picker.command_history, { desc = 'Command History' })
    vim.keymap.set('n', '<leader>sC', Snacks.picker.commands, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>sd', Snacks.picker.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sD', Snacks.picker.diagnostics_buffer, { desc = 'Buffer Diagnostics' })
    vim.keymap.set('n', '<leader>si', Snacks.picker.icons, { desc = 'Icons' })
    vim.keymap.set('n', '<leader>sj', Snacks.picker.jumps, { desc = 'Jumps' })
    vim.keymap.set('n', '<leader>sk', Snacks.picker.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sm', Snacks.picker.man, { desc = 'Man Pages' })
    vim.keymap.set('n', '<leader>sp', Snacks.picker.lazy, { desc = 'Search for Plugin Spec' })

    -- LSP
    vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions, { desc = 'Goto Definition' })
    vim.keymap.set('n', 'gD', Snacks.picker.lsp_declarations, { desc = 'Goto Declaration' })
    vim.keymap.set('n', 'gr', Snacks.picker.lsp_references, { desc = 'Goto References' })
    vim.keymap.set('n', 'gI', Snacks.picker.lsp_implementations, { desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gy', Snacks.picker.lsp_type_definitions, { desc = 'Goto T[y]pe Definition' })
    -- TODO: add gi/go for incoming/outcoming calls
    vim.keymap.set('n', '<leader>ss', Snacks.picker.lsp_symbols, { desc = 'Search Symbols' })
    vim.keymap.set('n', '<leader>sS', Snacks.picker.lsp_workspace_symbols, { desc = 'Search Workspace Symbols' })
    vim.keymap.set('n', '<leader>sS', Snacks.picker.lsp_workspace_symbols, { desc = 'Search Workspace Symbols' })
  end,
}
