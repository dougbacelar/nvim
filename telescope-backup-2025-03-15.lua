return -- fuzzy finding files and stuff
{
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-project.nvim' },

    { -- If encountering errors, see telescope-fzf-native README for install instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },

    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons' },
  },
  config = function()
    -- Two important keymaps to use while in telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      defaults = {
        -- truncate long paths from the beginning
        path_display = { 'truncate' },
        -- increase width from 80% to 85% to fit longer paths.
        layout_config = { width = 0.85 },
        mappings = {
          n = {
            ['dd'] = require('telescope.actions').delete_buffer,
            ['<leader>db'] = require('telescope.actions').delete_buffer,

            -- <C-n>/<Down>	next item
            -- <C-p>/<Up>	Previous item
            -- j/k	        Next/previous (in normal mode)
            -- H/M/L	        Select High/Middle/Low (in normal mode)
            -- gg/G	        Select the first/last item (in normal mode)
            -- <CR>	        Confirm selection
            -- <C-x>	        Go to file selection as a split
            -- <C-v>	        Go to file selection as a vsplit
            -- <C-t>	        Go to a file in a new tab
            -- <C-u>	        Scroll up in preview window
            -- <C-d>	        Scroll down in preview window
            -- <C-f>	        Scroll left in preview window
            -- <C-k>	        Scroll right in preview window
            -- <M-f>	        Scroll left in results window
            -- <M-k>	        Scroll right in results window
            -- <C-/>	        Show mappings for picker actions (insert mode)
            -- ?	        Show mappings for picker actions (normal mode)
            -- <C-c>	        Close telescope (insert mode)
            -- <Esc>	        Close telescope (in normal mode)
            -- <Tab>	        Toggle selection and move to next selection
            -- <S-Tab>	        Toggle selection and move to prev selection
            -- <C-q>	        Send all items not filtered to quickfixlist (qflist)
            -- <M-q>	        Send all selected items to qflist
            -- <C-r><C-w>	Insert cword in original window into prompt (insert mode)
            -- <C-r><C-a>	Insert cWORD in original window into prompt (insert mode)
            -- <C-r><C-f>	Insert cfile in original window into prompt (insert mode)
            -- <C-r><C-l>	Insert cline in original window into prompt (insert mode)
          },
        },
      },
      extensions = {
        -- pickers = {}

        project = {
          base_dirs = {
            '~/dev',
            '~/.config',
            '~/indeed',
          },
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable telescope extensions, if they are installed
    pcall(require('telescope').load_extension, 'project')
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = '[F]ind Git [F]iles' })
    vim.keymap.set('n', '<leader>fgf', builtin.git_files, { desc = '[F]ind [G]it [F]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fl', builtin.live_grep, { desc = '[F]ind [L]ive Grep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>f.', builtin.resume, { desc = '[F]ind Resume prev. picker ("." for repeat)' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent Files' })
    vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = '[F]ind [J]ump List' })
    vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = '[F]ind [G]it [C]ommits' })
    vim.keymap.set('n', '<leader>fgb', builtin.git_bcommits, { desc = '[F]ind [G]it [B]uffer Commits' })
    vim.keymap.set('n', '<leader>fb', builtin.git_branches, { desc = '[F]ind Git [B]ranches' })
    vim.keymap.set('n', '<leader>fgB', builtin.git_branches, { desc = '[F]ind [G]it [B]ranches' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>fp', "<cmd>lua require'telescope'.extensions.project.project{}<cr>", { desc = '[F]ind [P]rojects' })

    -- shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim files' })
  end,

