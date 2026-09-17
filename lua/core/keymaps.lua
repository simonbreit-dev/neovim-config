local map = vim.keymap.set

vim.api.nvim_create_user_command('QuickHelp', function()
  require('user.help').open()
end, { desc = 'Quick editing help' })
for _, key in ipairs { '<F1>', '<leader>?' } do
  map('n', key, '<cmd>QuickHelp<CR>', { desc = 'Quick editing help' })
end
map({ 'i', 'x' }, '<F1>', '<Esc><cmd>QuickHelp<CR>', { desc = 'Quick editing help' })

map('x', 'J', function()
  local last = math.max(vim.fn.line '.', vim.fn.line 'v')
  local distance = math.min(vim.v.count1, vim.api.nvim_buf_line_count(0) - last)
  return distance > 0 and (":move '>+" .. distance .. '<CR><cmd>undojoin<CR>gv=gv') or '<Ignore>'
end, { expr = true, desc = 'Move selected lines down' })
map('x', 'K', function()
  local first = math.min(vim.fn.line '.', vim.fn.line 'v')
  local distance = math.min(vim.v.count1, first - 1)
  return distance > 0 and (":move '<-" .. (distance + 1) .. '<CR><cmd>undojoin<CR>gv=gv') or '<Ignore>'
end, { expr = true, desc = 'Move selected lines up' })

map('n', '<leader>cp', function()
  require('user.editing').copy_path()
end, { desc = 'Copy file path' })
map('n', '<leader>cP', function()
  require('user.editing').copy_path(true)
end, { desc = 'Copy file path and line' })
map('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Word wrap ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { desc = 'Toggle word wrap' })
map('n', '<leader>tn', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.notify('Relative line numbers ' .. (vim.wo.relativenumber and 'enabled' or 'disabled'))
end, { desc = 'Toggle relative line numbers' })
map('n', '<leader>td', function()
  require('user.editing').toggle_diagnostic_text()
end, { desc = 'Toggle inline diagnostic text' })

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to location list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
