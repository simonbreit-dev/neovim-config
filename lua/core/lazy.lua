local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Failed to clone lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
  install = { colorscheme = { 'material-darker-custom', 'habamax' } },
  ui = {
    border = 'rounded',
    icons = vim.g.have_nerd_font and {} or {
      cmd = 'cmd',
      config = 'cfg',
      event = 'event',
      ft = 'ft',
      init = 'init',
      keys = 'keys',
      plugin = 'plug',
      runtime = 'rt',
      source = 'src',
      start = 'start',
      task = 'task',
      lazy = 'lazy',
    },
  },
}
