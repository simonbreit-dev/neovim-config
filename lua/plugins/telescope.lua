local function picker(name, opts)
  return function()
    require('telescope.builtin')[name](opts)
  end
end

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
    keys = {
      { '<leader><leader>', picker 'buffers', desc = 'Buffers' },
      { '<leader>/', picker 'current_buffer_fuzzy_find', desc = 'Search buffer' },
      { '<leader>sf', picker 'find_files', desc = 'Files' },
      { '<leader>sg', picker 'live_grep', desc = 'Grep' },
      { '<leader>sw', picker 'grep_string', desc = 'Word under cursor' },
      { '<leader>sd', picker 'diagnostics', desc = 'Diagnostics' },
      { '<leader>sh', picker 'help_tags', desc = 'Help' },
      { '<leader>sk', picker 'keymaps', desc = 'Keymaps' },
      { '<leader>sr', picker 'resume', desc = 'Resume search' },
      { '<leader>s.', picker 'oldfiles', desc = 'Recent files' },
      {
        '<leader>sn',
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Neovim config',
      },
    },
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
