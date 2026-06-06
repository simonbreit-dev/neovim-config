local M = {}

local function check_executable(name, required)
  if vim.fn.executable(name) == 1 then
    vim.health.ok(('found `%s`'):format(name))
  elseif required then
    vim.health.error(('missing required executable `%s`'):format(name))
  else
    vim.health.warn(('missing optional executable `%s`'):format(name))
  end
end

function M.check()
  vim.health.start 'personal Neovim configuration'

  local version = vim.version()
  if vim.version.ge(version, '0.11.0') then
    vim.health.ok(('Neovim %d.%d.%d'):format(version.major, version.minor, version.patch))
  else
    vim.health.error 'Neovim >= 0.11.0 is required'
  end

  check_executable('git', true)
  check_executable('rg', false)
  check_executable('fd', false)
  check_executable('make', false)
  check_executable('unzip', false)
  check_executable('node', false)
  check_executable('npm', false)
  check_executable('java', false)
  check_executable('javac', false)
  check_executable('go', false)
  check_executable('python3', false)

  if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
    vim.health.info 'SSH detected; OSC52 clipboard mode should be active.'
  else
    vim.health.info 'Local session detected; Neovim will use the normal system clipboard provider.'
  end
end

return M
