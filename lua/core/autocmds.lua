local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

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
