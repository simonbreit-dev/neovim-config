local M = {}
local diagnostic_text = { source = 'if_many', spacing = 2 }

function M.diagnostic_text()
  return vim.g.inline_diagnostics ~= false and diagnostic_text or false
end

function M.toggle_diagnostic_text()
  if vim.g.inline_diagnostics ~= false then
    local current = vim.diagnostic.config().virtual_text
    if current then
      diagnostic_text = current
    end
    vim.g.inline_diagnostics = false
  else
    vim.g.inline_diagnostics = true
  end
  vim.diagnostic.config { virtual_text = M.diagnostic_text() }
  vim.notify('Inline diagnostic text ' .. (vim.g.inline_diagnostics and 'enabled' or 'disabled'))
end

function M.copy_path(with_line)
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' or vim.bo.buftype ~= '' then
    vim.notify('No file path for this buffer.', vim.log.levels.WARN)
    return
  end
  local text = with_line and (path .. ':' .. vim.api.nvim_win_get_cursor(0)[1]) or path
  vim.fn.setreg('"', text)
  vim.fn.setreg('+', text)
  vim.notify('Copied: ' .. text)
end

return M
