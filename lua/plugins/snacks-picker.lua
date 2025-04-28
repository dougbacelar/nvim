return {
  -- Filter further by file type with
  --   `foo -- -type=lua`
  --   `foo -- -t=lua`
  --   `foo -- -type-not=lua`
  -- This only works on live grep, for other pickers use this instead
  --   `foo file:lua$`
  --   `foo file:!lua$`
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
            ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
            ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
            ['<c-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
            ['<c-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
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
    vim.keymap.set('n', '<leader>fh', Snacks.picker.help, { desc = 'Find Help' })
    vim.keymap.set('n', '<leader>fk', Snacks.picker.keymaps, { desc = 'Find Keymaps' })
    vim.keymap.set('n', '<leader>fF', function()
      Snacks.picker.files { hidden = true, ignored = true } -- TODO: add keymap for toggling ignored/hidden
    end, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>ff', Snacks.picker.git_files, { desc = 'Find Git Files' }) -- consider changing to files if really fast
    vim.keymap.set('n', '<leader>fgf', Snacks.picker.git_files, { desc = 'Find Git Files' })
    vim.keymap.set({ 'n', 'v' }, '<leader>fw', Snacks.picker.grep_word, { desc = 'Find current Word' })
    vim.keymap.set('n', '<leader>fl', Snacks.picker.grep, { desc = 'Find Live Grep' })
    vim.keymap.set('n', '<leader>/', Snacks.picker.search_history, { desc = 'Find Search History' })
    vim.keymap.set('n', '<leader>fd', Snacks.picker.diagnostics, { desc = 'Find Diagnostics' })
    vim.keymap.set('n', '<leader>fD', Snacks.picker.diagnostics_buffer, { desc = 'Find Diagnostics for Buffer' })
    vim.keymap.set('n', '<leader>f.', Snacks.picker.resume, { desc = 'Find Resume prev. picker ("." for repeat)' })
    vim.keymap.set('n', '<leader>fr', Snacks.picker.recent, { desc = 'Find Recent Files' })
    vim.keymap.set('n', '<leader>fj', Snacks.picker.jumps, { desc = 'Find Jump List' })
    vim.keymap.set('n', '<leader>fgc', Snacks.picker.git_log, { desc = 'Find Git Commits' })
    vim.keymap.set('n', '<leader>fgb', Snacks.picker.git_log_file, { desc = 'Find Git Buffer Commits' })
    vim.keymap.set('n', '<leader>fgB', Snacks.picker.git_branches, { desc = 'Find Git Branches' })
    vim.keymap.set('n', '<leader>fb', Snacks.picker.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader><leader>', Snacks.picker.smart, { desc = '[ ] Find Smart' })
    vim.keymap.set('n', '<leader>:', Snacks.picker.command_history, { desc = 'Find command history' })
    vim.keymap.set('n', '<leader>fc', Snacks.picker.commands, { desc = 'Find commands' })
    vim.keymap.set('n', '<leader>fm', Snacks.picker.man, { desc = 'Find man pages' })
    vim.keymap.set('n', '<leader>fP', Snacks.picker.lazy, { desc = 'Find Plugin Spec' })
    vim.keymap.set('n', '<leader>f"', Snacks.picker.registers, { desc = 'Find Registers' })
    vim.keymap.set('n', '<leader>e', function()
      Snacks.explorer()
    end, { desc = 'File Explorer' })
    vim.keymap.set('n', '<leader>`', function()
      Snacks.explorer()
    end, { desc = 'File Explorer' })
    vim.keymap.set('n', '<leader>fn', function()
      Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Find Neovim Config files' })
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

    -- LSP
    -- TODO: add gi/go for incoming/outcoming calls
    vim.keymap.set('n', 'gd', Snacks.picker.lsp_definitions, { desc = 'Goto Definition' })
    vim.keymap.set('n', 'grr', Snacks.picker.lsp_references, { desc = 'Goto References' }) -- default behaviour adds references to quick fix list
    vim.keymap.set('n', 'gI', Snacks.picker.lsp_implementations, { desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gy', Snacks.picker.lsp_type_definitions, { desc = 'Goto Type Definition (tYpe)' })
    vim.keymap.set('n', '<leader>fs', Snacks.picker.lsp_symbols, { desc = 'Search Symbols' })
    vim.keymap.set('n', '<leader>fS', Snacks.picker.lsp_workspace_symbols, { desc = 'Search Workspace Symbols' })
  end,
}
