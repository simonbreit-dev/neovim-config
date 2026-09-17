local languages = require 'config.languages'

local function format_on_save(bufnr)
  if vim.g.format_on_save == false or vim.b[bufnr].format_on_save == false then
    return
  end

  local disabled = {
    c = true,
    cpp = true,
  }

  if disabled[vim.bo[bufnr].filetype] then
    return
  end

  return {
    timeout_ms = 3000,
    lsp_format = 'fallback',
  }
end

return {
  {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    event = { 'BufWritePre' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = { 'n', 'v' },
        desc = 'Format',
      },
      {
        '<leader>tf',
        function()
          if vim.g.format_on_save == false then
            vim.notify('Format on save is disabled globally; set vim.g.format_on_save = true to enable it.', vim.log.levels.WARN)
            return
          end
          vim.b.format_on_save = vim.b.format_on_save == false
          vim.notify('Format on save ' .. (vim.b.format_on_save and 'enabled' or 'disabled'))
        end,
        desc = 'Toggle format on save',
      },
    },
    opts = {
      notify_on_error = true,
      notify_no_formatters = false,
      format_on_save = format_on_save,
      formatters_by_ft = languages.formatters_by_ft,
      formatters = {
        prettier_svelte = {
          inherit = 'prettier',
          condition = function(_, ctx)
            return require('user.node').svelte_formatter(ctx.dirname) ~= nil
          end,
          prepend_args = function(_, ctx)
            return { '--plugin', require('user.node').svelte_formatter(ctx.dirname) }
          end,
        },
      },
    },
  },
}
