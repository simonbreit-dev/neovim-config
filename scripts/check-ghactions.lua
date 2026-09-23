-- Run with: nvim --headless -u NONE -i NONE -l scripts/check-ghactions.lua
-- Uses installed plugins/tools, but disables automatic installs and update checks.
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.o.loadplugins = true
local data = vim.fn.stdpath 'data'
vim.opt.rtp:prepend(data .. '/lazy/lazy.nvim')
vim.opt.rtp:prepend(data .. '/lazy/mason.nvim')
vim.opt.rtp:prepend(data .. '/lazy/mason-tool-installer.nvim')
vim.opt.rtp:prepend(data .. '/lazy/nvim-treesitter')
local installer = require 'mason-tool-installer'
local setup = installer.setup
installer.setup = function(opts)
  opts.run_on_start = false
  setup(opts)
end
local ts = require 'nvim-treesitter'
ts.install = function()
  return { await = function() end }
end
local lazy = require 'lazy'
local lazy_setup = lazy.setup
lazy.setup = function(opts)
  opts.checker = { enabled = false }
  lazy_setup(opts)
end

local errors = {}
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if level == vim.log.levels.ERROR then
    errors[#errors + 1] = msg
  end
  notify(msg, level, opts)
end
dofile 'init.lua'
vim.o.swapfile = false
vim.o.hidden = true
local root = vim.fn.tempname()
vim.fn.mkdir(root .. '/.github/workflows', 'p')
local workflow = {
  'name: Test',
  'on: push',
  'jobs:',
  '  test:',
  '    runs-on: ubuntu-latest',
  '    steps:',
  '      - run: echo "$REF"',
  '        env:',
  '          REF: ${{ github.ref }}',
}
local function open(path, lines, ft)
  local filename = root .. '/' .. path
  vim.fn.writefile(lines, filename)
  vim.cmd.edit(vim.fn.fnameescape(filename))
  local buf = vim.api.nvim_get_current_buf()
  assert(vim.bo[buf].filetype == ft, path .. ': ' .. vim.bo[buf].filetype)
  assert(vim.treesitter.language.get_lang(ft) == 'yaml')
  assert(vim.treesitter.highlighter.active[buf], 'Treesitter did not attach: ' .. path)
  assert(vim.treesitter.get_parser(buf):lang() == 'yaml')
  assert(vim.treesitter.query.get('yaml', 'highlights'))
  return buf
end
local function client(buf, name)
  assert(
    vim.wait(15000, function()
      local clients = vim.lsp.get_clients { bufnr = buf }
      return #clients == 1 and clients[1].name == name and clients[1].initialized
    end, 50),
    'Expected only ' .. name .. ': ' .. vim.inspect(vim.lsp.get_clients { bufnr = buf })
  )
  return vim.lsp.get_clients({ bufnr = buf })[1]
end
local lint = require 'lint'
local function lint_buffer(buf, name, expect_errors)
  local ns = lint.get_namespace(name)
  vim.diagnostic.reset(ns, buf)
  require('user.lint').run(buf, true)
  assert(
    vim.wait(10000, function()
      return #lint.get_running(buf) == 0
    end, 50),
    'Linter timed out'
  )
  local diagnostics = vim.diagnostic.get(buf, { namespace = ns })
  assert((#diagnostics > 0) == expect_errors, name .. ': ' .. vim.inspect(diagnostics))
  return diagnostics
end

for _, path in ipairs { 'config.yml', 'config.yaml', '.github/other.yml', 'workflows.yml' } do
  assert(vim.filetype.match { filename = root .. '/' .. path } == 'yaml', path)
end
local buf = open('.github/workflows/test.yml', workflow, 'yaml.ghactions')
local actions = client(buf, 'gh_actions_ls')
assert(actions:supports_method 'textDocument/completion')
local response = actions:request_sync('textDocument/completion', {
  textDocument = { uri = vim.uri_from_bufnr(buf) },
  position = { line = 8, character = 26 }, -- after github.
}, 10000, buf)
assert(response and not response.err and response.result, vim.inspect(response))
local items = response.result.items or response.result
assert(#items > 0, 'No Actions completion items')
print('Actions completion items: ' .. #items)
lint_buffer(buf, 'actionlint', false)
assert(#vim.diagnostic.get(buf, { namespace = lint.get_namespace 'yamllint' }) == 0)
-- Wait for initial LSP diagnostics, then verify a valid expression is accepted.
vim.wait(1500, function()
  return false
end, 50)
assert(#vim.diagnostic.get(buf) == 0, vim.inspect(vim.diagnostic.get(buf)))
vim.api.nvim_buf_set_lines(buf, 8, 9, false, { '          REF: ${{ nonexistent.ref }}' })
local diagnostics = lint_buffer(buf, 'actionlint', true)
assert(vim.iter(diagnostics):any(function(d)
  return d.message:find('nonexistent', 1, true) ~= nil
end))
assert(
  vim.wait(10000, function()
    return #vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(actions.id) }) > 0
  end, 50),
  'Actions LSP did not diagnose invalid expression'
)
open('.github/workflows/test.yaml', workflow, 'yaml.ghactions')
client(vim.api.nvim_get_current_buf(), 'gh_actions_ls')
local yaml = open('config.yml', { '---', 'key: value', 'key: duplicate' }, 'yaml')
client(yaml, 'yamlls')
local yaml_diagnostics = lint_buffer(yaml, 'yamllint', true)
assert(vim.iter(yaml_diagnostics):any(function(d)
  return d.message:find('duplication', 1, true) ~= nil
end))
require('lazy').load { plugins = { 'conform.nvim' } }
local conform = require 'conform'
for _, target in ipairs { buf, yaml } do
  local formatters = conform.list_formatters(target)
  assert(#formatters > 0 and (formatters[1].name == 'prettierd' or formatters[1].name == 'prettier'))
end
for name, config in pairs(require('config.languages').lsp) do
  if not config.condition or config.condition() then
    assert(vim.lsp.is_enabled(name), name .. ' not enabled')
  end
end
assert(#errors == 0, table.concat(errors, '\n'))
print 'PASS: filetypes, YAML highlighters, Actions completion/diagnostics, actionlint, yamllint, formatter selection, and LSP configuration'
if vim.env.NVIM_GHACTIONS_HEALTH then
  vim.cmd 'checkhealth'
  vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), vim.env.NVIM_GHACTIONS_HEALTH)
end
for _, attached in ipairs(vim.lsp.get_clients()) do
  attached:stop(true)
end
vim.fn.delete(root, 'rf')
vim.cmd 'qa!'
