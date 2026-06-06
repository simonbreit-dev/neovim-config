local languages = require 'config.languages'

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      ensure_installed = languages.treesitter,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function()
      local ts = require 'nvim-treesitter'
      ts.setup()

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter-start', { clear = true }),
        callback = function(event)
          local ok = pcall(vim.treesitter.start, event.buf)
          if ok then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
