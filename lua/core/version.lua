local minimum = { 0, 11, 0 }
local version = vim.version()

if vim.version.lt(version, minimum) then
  local current = string.format('%d.%d.%d', version.major, version.minor, version.patch)
  local required = string.format('%d.%d.%d', minimum[1], minimum[2], minimum[3])
  vim.schedule(function()
    vim.notify(('This configuration requires Neovim >= %s. Current version: %s.'):format(required, current), vim.log.levels.ERROR)
  end)
  error(('Neovim >= %s required, found %s'):format(required, current))
end
