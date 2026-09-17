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
  if vim.version.ge(version, require 'core.version') then
    vim.health.ok(('Neovim %d.%d.%d'):format(version.major, version.minor, version.patch))
  else
    vim.health.error 'Neovim >= 0.12.0 is required'
  end

  check_executable('git', true)
  check_executable('curl', true)
  check_executable('tar', true)
  local compiler = vim.fn.executable 'cc' == 1 or vim.fn.executable 'gcc' == 1 or vim.fn.executable 'clang' == 1
  if compiler then
    vim.health.ok 'found a C compiler'
  else
    vim.health.error 'A C compiler is required to build Treesitter parsers'
  end
  if vim.fn.executable 'tree-sitter' == 1 then
    local cli = vim.system({ 'tree-sitter', '--version' }, { text = true }):wait(3000)
    local cli_version = (cli.stdout or ''):match '%d+%.%d+%.%d+'
    if cli.code == 0 and cli_version and vim.version.ge(cli_version, '0.26.1') then
      vim.health.ok('tree-sitter CLI ' .. cli_version)
    else
      vim.health.error 'tree-sitter CLI >= 0.26.1 is required'
    end
  else
    vim.health.error 'Missing tree-sitter CLI >= 0.26.1 (install from a package manager, not npm)'
  end
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
  check_executable('dotnet', false)

  if vim.fn.executable 'java' == 1 then
    local java = vim.system({ 'java', '-version' }, { text = true }):wait(3000)
    if java.code == 0 then
      vim.health.ok(vim.trim((java.stderr or ''):match '[^\n]+' or 'Java runtime is available'))
    else
      vim.health.warn 'Java is on PATH but cannot start; install/configure a JDK for Java support'
    end
  end
  if vim.fn.executable 'dotnet' == 1 then
    local sdk = vim.system({ 'dotnet', '--list-sdks' }, { text = true }):wait(3000)
    if sdk.code == 0 and (sdk.stdout or ''):match '%d+%.%d+%.%d+' then
      vim.health.ok 'a .NET SDK is available for C# project loading'
    else
      vim.health.warn 'A .NET SDK is required for C# project loading'
    end
  end

  local missing = {}
  for _, lang in ipairs(require('config.languages').treesitter) do
    if not pcall(vim.treesitter.language.add, lang) then
      table.insert(missing, lang)
    end
  end
  if #missing == 0 then
    vim.health.ok 'all configured Treesitter parsers are available'
  else
    vim.health.warn('Missing parsers: ' .. table.concat(missing, ', ') .. '. Wait for automatic installation or see :TSLog.')
  end

  if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
    vim.health.info 'SSH detected; OSC52 clipboard mode should be active.'
  else
    vim.health.info 'Local session detected; Neovim will use the normal system clipboard provider.'
  end
end

return M
