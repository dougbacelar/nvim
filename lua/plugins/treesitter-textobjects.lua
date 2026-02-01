return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    config = function()
      local select = require 'nvim-treesitter-textobjects.select'

      -- Helper function to create textobject keymaps
      local function map_textobj(keys, query, desc)
        vim.keymap.set({ 'x', 'o' }, keys, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = desc })
      end

      -- Select textobjects
      map_textobj('a=', '@assignment.outer', 'Select outer part of an assignment')
      map_textobj('i=', '@assignment.inner', 'Select inner part of an assignment')
      map_textobj('l=', '@assignment.lhs', 'Select left hand side of an assignment')
      map_textobj('r=', '@assignment.rhs', 'Select right hand side of an assignment')

      map_textobj('aa', '@parameter.outer', 'Select outer part of a parameter/argument')
      map_textobj('ia', '@parameter.inner', 'Select inner part of a parameter/argument')

      map_textobj('ai', '@conditional.outer', 'Select outer part of a conditional')
      map_textobj('ii', '@conditional.inner', 'Select inner part of a conditional')

      map_textobj('ar', '@loop.outer', 'Select outer part of a loop')
      map_textobj('ir', '@loop.inner', 'Select inner part of a loop')

      map_textobj('af', '@call.outer', 'Select outer part of a function call')
      map_textobj('if', '@call.inner', 'Select inner part of a function call')

      map_textobj('am', '@function.outer', 'Select outer part of a method/function definition')
      map_textobj('im', '@function.inner', 'Select inner part of a method/function definition')

      map_textobj('ac', '@class.outer', 'Select outer part of a class')
      map_textobj('ic', '@class.inner', 'Select inner part of a class')

      -- Swap textobjects
      local swap = require 'nvim-treesitter-textobjects.swap'

      vim.keymap.set('n', '<leader>sna', function()
        swap.swap_next('@parameter.inner', 'textobjects')
      end, { desc = 'Swap parameter with next' })

      vim.keymap.set('n', '<leader>snm', function()
        swap.swap_next('@function.outer', 'textobjects')
      end, { desc = 'Swap function with next' })

      vim.keymap.set('n', '<leader>sla', function()
        swap.swap_previous('@parameter.inner', 'textobjects')
      end, { desc = 'Swap parameter with previous' })

      vim.keymap.set('n', '<leader>slm', function()
        swap.swap_previous('@function.outer', 'textobjects')
      end, { desc = 'Swap function with previous' })

      -- Move to next/previous textobjects
      local move = require 'nvim-treesitter-textobjects.move'

      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        move.goto_next_start('@call.outer', 'textobjects')
      end, { desc = 'Next function call start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next method/function def start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']i', function()
        move.goto_next_start('@conditional.outer', 'textobjects')
      end, { desc = 'Next conditional start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']r', function()
        move.goto_next_start('@loop.outer', 'textobjects')
      end, { desc = 'Next loop start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
        move.goto_next_start('@parameter.outer', 'textobjects')
      end, { desc = 'Next parameter start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
        move.goto_next_end('@call.outer', 'textobjects')
      end, { desc = 'Next function call end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next method/function def end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']I', function()
        move.goto_next_end('@conditional.outer', 'textobjects')
      end, { desc = 'Next conditional end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']R', function()
        move.goto_next_end('@loop.outer', 'textobjects')
      end, { desc = 'Next loop end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']A', function()
        move.goto_next_end('@parameter.outer', 'textobjects')
      end, { desc = 'Next parameter end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        move.goto_previous_start('@call.outer', 'textobjects')
      end, { desc = 'Prev function call start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Prev method/function def start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Prev class start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[i', function()
        move.goto_previous_start('@conditional.outer', 'textobjects')
      end, { desc = 'Prev conditional start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[r', function()
        move.goto_previous_start('@loop.outer', 'textobjects')
      end, { desc = 'Prev loop start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
        move.goto_previous_start('@parameter.outer', 'textobjects')
      end, { desc = 'Prev parameter start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
        move.goto_previous_end('@call.outer', 'textobjects')
      end, { desc = 'Prev function call end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Prev method/function def end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Prev class end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[I', function()
        move.goto_previous_end('@conditional.outer', 'textobjects')
      end, { desc = 'Prev conditional end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[R', function()
        move.goto_previous_end('@loop.outer', 'textobjects')
      end, { desc = 'Prev loop end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[A', function()
        move.goto_previous_end('@parameter.outer', 'textobjects')
      end, { desc = 'Prev parameter end' })

      -- Repeatable move support
      local ts_repeat = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Make ; and , repeat last move (vim way: ; goes in the direction you were moving)
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat.repeat_last_move_opposite)

      -- Make f, F, t, T repeatable
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat.builtin_T_expr, { expr = true })

      -- Gitsigns hunk navigation (not repeatable in new API, but still functional)
      local gs = require 'gitsigns'
      vim.keymap.set({ 'n', 'x', 'o' }, ']h', function()
        gs.nav_hunk 'next'
      end, { desc = 'Next Hunk' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[h', function()
        gs.nav_hunk 'prev'
      end, { desc = 'Previous Hunk' })
    end,
  },
}
