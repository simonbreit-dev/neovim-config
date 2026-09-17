return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    keys = {
      {
        '<leader>cl',
        function()
          require('user.lint').run(vim.api.nvim_get_current_buf(), true)
        end,
        desc = 'Lint buffer',
      },
      {
        '<leader>tl',
        function()
          require('user.lint').toggle()
        end,
        desc = 'Toggle automatic external linting',
      },
    },
    config = function()
      require('user.lint').setup()
    end,
  },
}
