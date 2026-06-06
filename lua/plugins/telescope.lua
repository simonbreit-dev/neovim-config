return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = function()
      local builtin = require 'telescope.builtin'
      return {
        { '<leader><leader>', builtin.buffers, desc = 'Buffers' },
        { '<leader>/', builtin.current_buffer_fuzzy_find, desc = 'Search buffer' },
        { '<leader>sf', builtin.find_files, desc = 'Files' },
        { '<leader>sg', builtin.live_grep, desc = 'Grep' },
        { '<leader>sw', builtin.grep_string, desc = 'Word under cursor' },
        { '<leader>sd', builtin.diagnostics, desc = 'Diagnostics' },
        { '<leader>sh', builtin.help_tags, desc = 'Help' },
        { '<leader>sk', builtin.keymaps, desc = 'Keymaps' },
        { '<leader>sr', builtin.resume, desc = 'Resume search' },
        { '<leader>s.', builtin.oldfiles, desc = 'Recent files' },
        {
          '<leader>sn',
          function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
          end,
          desc = 'Neovim config',
        },
      }
    end,
    opts = function()
      local actions = require 'telescope.actions'
      return {
        defaults = {
          mappings = {
            i = {
              ['<esc>'] = actions.close,
            },
          },
        },
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
    end,
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
    end,
  },
}
