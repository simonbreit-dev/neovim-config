local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufWinEnter', {
  desc = 'Restore the last cursor position when opening a file',
  group = augroup('user-restore-cursor', { clear = true }),
  callback = function(event)
    if vim.b[event.buf].user_cursor_restored or vim.bo[event.buf].buftype ~= '' or vim.api.nvim_buf_get_name(event.buf) == '' then
      return
    end
    if vim.wo.diff or vim.bo[event.buf].filetype == 'gitcommit' or vim.bo[event.buf].filetype == 'gitrebase' or vim.bo[event.buf].filetype == 'xxd' then
      return
    end
    vim.b[event.buf].user_cursor_restored = true
    if not vim.deep_equal(vim.api.nvim_win_get_cursor(0), { 1, 0 }) then
      return
    end
    local position = vim.api.nvim_buf_get_mark(event.buf, '"')
    if position[1] > 0 and position[1] <= vim.api.nvim_buf_line_count(event.buf) then
      vim.api.nvim_win_set_cursor(0, position)
    end
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'GitLab CI filetype',
  group = augroup('user-gitlab-ci-filetype', { clear = true }),
  pattern = { '.gitlab-ci.yml', '.gitlab-ci.yaml', 'gitlab-ci.yml', 'gitlab-ci.yaml' },
  callback = function(event)
    vim.bo[event.buf].filetype = 'yaml.gitlab'
  end,
})
