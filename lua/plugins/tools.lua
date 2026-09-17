local languages = require 'config.languages'

return {
  {
    'mason-org/mason.nvim',
    lazy = false,
    opts = { ui = { border = 'rounded' } },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = languages.mason_ensure_installed(),
      auto_update = false,
      run_on_start = true,
      start_delay = 1000,
      integrations = { ['mason-lspconfig'] = false, ['mason-null-ls'] = false, ['mason-nvim-dap'] = false },
    },
  },
}
