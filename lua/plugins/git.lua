return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, 'Next git change')
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, 'Previous git change')
        map({ 'n', 'v' }, '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
        map({ 'n', 'v' }, '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
        map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>gR', gitsigns.reset_buffer, 'Reset buffer')
        map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
        map('n', '<leader>gb', gitsigns.blame_line, 'Blame line')
        map('n', '<leader>gd', gitsigns.diffthis, 'Diff against index')
        map('n', '<leader>gD', function()
          gitsigns.diffthis '@'
        end, 'Diff against HEAD')
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'Toggle blame')
      end,
    },
  },
  { 'tpope/vim-fugitive', cmd = { 'Git', 'G' }, keys = { { '<leader>gg', '<cmd>Git<cr>', desc = 'Git status' } } },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<cr>', desc = 'Diff view' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    },
  },
}
