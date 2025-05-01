return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- if lazy loading causes issues or conflicts with mini.ai, disable it here
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter.configs').setup {

        textobjects = {
          select = {
            enable = true,

            -- allow to jump forward to next text object
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
              ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
              ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
              ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

              ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
              ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

              ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
              ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

              ['ar'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
              ['ir'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

              ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
              ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

              ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
              ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

              ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
            },
          },
          swap = {
            -- consider removing these, not used very often
            enable = true,
            swap_next = {
              ['<leader>sna'] = '@parameter.inner', -- swap parameters/argument with next
              ['<leader>snm'] = '@function.outer', -- swap function with next
            },
            swap_previous = {
              ['<leader>sla'] = '@parameter.inner', -- swap parameters/argument with prev
              ['<leader>slm'] = '@function.outer', -- swap function with previous
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = { query = '@call.outer', desc = 'Next function call start' },
              [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
              [']r'] = { query = '@loop.outer', desc = 'Next loop start' },
              [']a'] = { query = '@parameter.outer', desc = 'Next parameter start' },
              -- not sure what this does but it wont work as ]s is assigned to 'next mispelled word'
              -- [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
            },
            goto_next_end = {
              [']F'] = { query = '@call.outer', desc = 'Next function call end' },
              [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
              [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
              [']R'] = { query = '@loop.outer', desc = 'Next loop end' },
              [']A'] = { query = '@parameter.outer', desc = 'Next parameter start' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
              ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
              ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
              ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
              ['[r'] = { query = '@loop.outer', desc = 'Prev loop start' },
              ['[a'] = { query = '@parameter.outer', desc = 'Prev parameter start' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
              ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
              ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
              ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
              ['[R'] = { query = '@loop.outer', desc = 'Prev loop end' },
              ['[A'] = { query = '@parameter.outer', desc = 'Prev parameter start' },
            },
          },
        },
      }

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })

      -- make diagnostic navigation repeatable
      -- local next_diagnostic_repeat, prev_diagnostic_repeat = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
      -- vim.keymap.set({ 'n', 'x', 'o' }, ']d', next_diagnostic_repeat, { desc = 'Next Diagnostic' })
      -- vim.keymap.set({ 'n', 'x', 'o' }, '[d', prev_diagnostic_repeat, { desc = 'Previous Diagnostic' })

      -- make hunk navigation repeatable
      local gs = require 'gitsigns'
      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(function()
        return gs.nav_hunk 'next'
      end, function()
        return gs.nav_hunk 'prev'
      end)
      vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk_repeat, { desc = 'Next Hunk' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat, { desc = 'Previous Hunk' })
    end,
  },
}
