return {
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
    keys = {
      { '<leader>st', '<cmd>TodoTelescope<cr>', desc = 'Search TODOs' },
    },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'numToStr/Comment.nvim',
    keys = { 'gcc', 'gbc', { 'gc', mode = 'v' }, { 'gb', mode = 'v' } },
    opts = {},
  },
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>e',
        function()
          local path = vim.api.nvim_buf_get_name(0)
          require('mini.files').open(path ~= '' and path or vim.uv.cwd(), true)
        end,
        desc = 'File explorer',
      },
    },
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.files').setup {
        windows = { preview = true, width_focus = 35, width_preview = 70 },
      }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
