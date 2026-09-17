local M = {}
local languages = require 'config.languages'
local pending = {}
local eslint_configs = {
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.json',
  '.eslintrc.yaml',
  '.eslintrc.yml',
}

local function eslint_root(bufnr)
  return vim.fs.root(bufnr, function(name, path)
    if vim.tbl_contains(eslint_configs, name) then
      return true
    end
    if name == 'package.json' then
      local ok, package = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(path, name)), '\n'))
      end)
      return ok and type(package) == 'table' and package.eslintConfig ~= nil
    end
    return false
  end)
end

local function node_command(name)
  local filename = vim.api.nvim_buf_get_name(0)
  for dir in vim.fs.parents(filename) do
    local cmd = vim.fs.joinpath(dir, 'node_modules', '.bin', name)
    if vim.fn.executable(cmd) == 1 then
      return cmd
    end
  end
  return name
end

function M.run(bufnr, manual)
  if not vim.api.nvim_buf_is_valid(bufnr) or (not manual and vim.g.lint_on_events == false) then
    return
  end
  if not vim.bo[bufnr].modifiable or vim.bo[bufnr].buftype ~= '' then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    local lint = require 'lint'
    local names = languages.linters_by_ft[vim.bo.filetype] or languages.linters_by_ft[vim.bo.filetype:match '^[^.]+'] or {}
    local cwd = vim.fs.root(bufnr, { '.htmlhintrc', '.yamllint', '.yamllint.yml', '.yamllint.yaml', '.markdownlint.json', '.markdownlint-cli2.jsonc', '.git' })
      or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
      or vim.uv.cwd()

    for _, name in ipairs(names) do
      if name == 'eslint' or name == 'eslint_d' then
        cwd = eslint_root(bufnr)
        if not cwd then
          if manual then
            vim.notify('No ESLint configuration found for this buffer.', vim.log.levels.WARN)
          end
          return
        end
      end
      local linter = lint.linters[name]
      local cmd = linter and (type(linter.cmd) == 'function' and linter.cmd() or linter.cmd)
      if cmd and vim.fn.executable(cmd) == 1 then
        -- Each list describes alternatives, not duplicate instances of a linter.
        lint.try_lint(name, { cwd = cwd })
        return
      end
    end
    if manual and #names > 0 then
      vim.notify('No external linter available for this buffer; check :Mason.', vim.log.levels.WARN)
    end
  end)
end

function M.toggle()
  vim.g.lint_on_events = not vim.g.lint_on_events
  if not vim.g.lint_on_events then
    local lint = require 'lint'
    for _, names in pairs(languages.linters_by_ft) do
      for _, name in ipairs(names) do
        vim.diagnostic.reset(lint.get_namespace(name))
      end
    end
  else
    M.run(vim.api.nvim_get_current_buf())
  end
  vim.notify('Automatic external linting ' .. (vim.g.lint_on_events and 'enabled' or 'disabled'))
end

function M.setup()
  local lint = require 'lint'
  lint.linters_by_ft = vim.deepcopy(languages.linters_by_ft)
  for _, name in ipairs { 'eslint', 'eslint_d', 'htmlhint' } do
    lint.linters[name].cmd = function()
      return node_command(name)
    end
  end
  local group = vim.api.nvim_create_augroup('user-lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
    group = group,
    callback = function(event)
      pending[event.buf] = (pending[event.buf] or 0) + 1
      local generation = pending[event.buf]
      vim.defer_fn(function()
        if pending[event.buf] == generation then
          M.run(event.buf)
        end
      end, 150)
    end,
  })
  vim.api.nvim_create_autocmd('BufWipeout', {
    group = group,
    callback = function(event)
      pending[event.buf] = nil
    end,
  })
end

return M
