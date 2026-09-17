return {
  { 'NMAC427/guess-indent.nvim', event = 'BufReadPost', opts = {} },
  { 'nvim-tree/nvim-web-devicons', lazy = true, enabled = vim.g.have_nerd_font },
  { import = 'plugins.ui' },
  { import = 'plugins.editor' },
  { import = 'plugins.git' },
  { import = 'plugins.telescope' },
  { import = 'plugins.lsp' },
  { import = 'plugins.tools' },
  { import = 'plugins.completion' },
  { import = 'plugins.format' },
  { import = 'plugins.lint' },
  { import = 'plugins.treesitter' },
}
