local languages = require 'config.languages'

local function executable_for_linter(lint, name)
  local linter = lint.linters[name]
  if not linter then
    return false
  end

  local cmd = type(linter.cmd) == 'function' and linter.cmd() or linter.cmd
  return cmd and vim.fn.executable(cmd) == 1
end

local function available_linters(lint, names)
  return vim.tbl_filter(function(name)
    return executable_for_linter(lint, name)
  end, names)
end

return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {}
      for ft, linters in pairs(languages.linters_by_ft) do
        local available = available_linters(lint, linters)
        if #available > 0 then
          lint.linters_by_ft[ft] = available
        end
      end

      local function try_lint()
        if vim.g.lint_on_events == false or not vim.bo.modifiable or vim.bo.buftype ~= '' then
          return
        end
        pcall(lint.try_lint)
      end

      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('user-lint', { clear = true }),
        callback = try_lint,
      })

      vim.keymap.set('n', '<leader>cl', try_lint, { desc = 'Lint buffer' })
      vim.keymap.set('n', '<leader>tl', function()
        vim.g.lint_on_events = not vim.g.lint_on_events
        vim.notify('Lint on events ' .. (vim.g.lint_on_events and 'enabled' or 'disabled'))
      end, { desc = 'Toggle lint on events' })
    end,
  },
}
