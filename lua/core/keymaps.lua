local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics to location list' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
