local M = {}

function M.package(name, start)
  local dir = start
  while dir do
    local path = vim.fs.joinpath(dir, 'node_modules', name)
    if vim.uv.fs_stat(vim.fs.joinpath(path, 'package.json')) then
      return path, dir
    end
    local parent = vim.fs.dirname(dir)
    dir = parent ~= dir and parent or nil
  end
end

function M.svelte_package(name, start)
  local path, root = M.package(name, start)
  if path then
    return path, root
  end
  local mason = require('mason.settings').current.install_root_dir
  return M.package(name, vim.fs.joinpath(mason, 'packages', 'svelte-language-server', 'node_modules', 'svelte-language-server'))
end

function M.svelte_formatter(start)
  local path = M.svelte_package('prettier-plugin-svelte', start)
  if path then
    local package = vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(path, 'package.json')), '\n'))
    return vim.fs.joinpath(path, package.main or 'plugin.js')
  end
end

return M
