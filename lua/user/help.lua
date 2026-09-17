local M = {}
local window
local namespace = vim.api.nvim_create_namespace 'user-quick-help'

local lines = {
  'Press Esc before using normal-mode commands.',
  'Space cf means: press Space, then c, then f.',
  'Scroll: j/k, Ctrl-d/u   Close: q, Esc, or F1',
  '',
  'SELECT',
  '  v           Select characters; move to extend the selection',
  '  V           Select whole lines; j/k extends the selection',
  '  Ctrl-v      Select a rectangular block',
  '  viw         Select the word under the cursor',
  '  vip         Select the current paragraph',
  '  ggVG        Select the whole file',
  '  Esc         Cancel selection; gv selects it again',
  '  J / K       Move selected lines down / up; keep them selected',
  '  j/k extends the selection; uppercase J/K moves its lines.',
  '',
  'YANK (COPY) AND PASTE',
  '  y           Copy the selection',
  '  yy / yiw    Copy the current line / word (normal mode)',
  '  p / P       Paste after / before the cursor (normal mode)',
  '  Copies use the system clipboard when available.',
  '  Over SSH, copying uses OSC52; paste depends on the terminal.',
  "  Space cp    Copy this file's absolute path",
  '  Space cP    Copy the path with the current line (path:line)',
  '',
  'CUT AND DELETE',
  '  d           Cut the selection: delete it and keep it for paste',
  '  dd / diw    Cut the current line / word (normal mode)',
  '  x / D       Delete a character / to line end (normal mode)',
  '  Deletes also replace the copied text.',
  '  "_d / "_dd  Delete selection / line without replacing copied text',
  '  u / Ctrl-r  Undo / redo (normal mode)',
  '',
  'FORMAT',
  '  Space cf    Format the whole buffer (normal mode)',
  '  v or V, then Space cf: format the selection',
  '  Selection formatting depends on the language and formatter.',
  '  :w          Save; formatting runs automatically by default',
  '  Space tf    Toggle format on save for this buffer',
  '  :ConformInfo  Check the configured formatter and errors',
  '',
  'FIND AND REPLACE',
  '  /text       Find text; Enter to search, n/N for next/previous',
  '  *           Find the word under the cursor',
  '  Esc         Clear search highlighting (normal mode)',
  '  :%s/old/new/gc  Replace throughout this file, with confirmation',
  '  Select text, press :, then type s/old/new/gc',
  '  The selection adds the line range automatically.',
  '  This replaces across selected lines, including unselected text.',
  '  For matches starting in the selection: s/\\%Vold/new/gc',
  '  Patterns are regular expressions; replacement previews live.',
  '  Confirm: y yes, n skip, a all remaining, q stop; u to undo.',
  '',
  'DISPLAY',
  '  Space tw    Toggle word wrap in this window',
  '  Space tn    Toggle relative line numbers in this window',
  '  Space td    Toggle inline diagnostic text globally',
  '  Diagnostics still appear in signs, underlines, and lists.',
  '',
  'NAVIGATE AND EDIT',
  '  Files reopen at the last cursor position.',
  '  Space e     Open the file explorer',
  '  Space sf / Space sg  Find files / search across files',
  '  Space Space  Switch buffers; Space s. opens recent files',
  '  gcc         Toggle a line comment; select lines then gc',
  '  ]c / [c     Next / previous Git change',
  '  Space gp / Space gg  Preview Git change / open Git status',
  '  Undo history persists after closing and reopening files.',
  '',
  'MORE HELP',
  '  Space      Pause to see available shortcuts (which-key)',
  '  Space sk   Search all keymaps',
  '  Space sh   Search Neovim help topics',
  '  :help visual  Read the selection guide',
  '  F1 / Space ? / :QuickHelp  Open this guide',
}

local function dimensions()
  local width = math.max(1, math.min(78, vim.o.columns - 4))
  local height = math.max(1, math.min(#lines, vim.o.lines - vim.o.cmdheight - 4))
  return {
    relative = 'editor',
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - vim.o.cmdheight - height - 2) / 2)),
    col = math.max(0, math.floor((vim.o.columns - width - 2) / 2)),
  }
end

function M.open()
  if window and vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_set_current_win(window)
    return
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.bo[buffer].bufhidden = 'wipe'
  vim.bo[buffer].modifiable = false
  local config = vim.tbl_extend('force', dimensions(), {
    style = 'minimal',
    border = 'rounded',
    title = ' Quick editing help ',
    title_pos = 'center',
  })
  window = vim.api.nvim_open_win(buffer, true, config)
  vim.wo[window].wrap = true
  vim.wo[window].linebreak = true
  vim.wo[window].cursorline = true
  vim.wo[window].scrolloff = 0

  for index, line in ipairs(lines) do
    if line:match '^[A-Z][A-Z ()]+$' then
      vim.api.nvim_buf_set_extmark(buffer, namespace, index - 1, 0, { end_col = #line, hl_group = 'Title' })
    elseif line:match '^  %S' then
      local key_end = line:find('  ', 3, true)
      if key_end then
        vim.api.nvim_buf_set_extmark(buffer, namespace, index - 1, 2, { end_col = key_end - 1, hl_group = 'Special' })
      end
    end
  end

  local help_window = window
  for _, key in ipairs { 'q', '<Esc>', '<F1>' } do
    vim.keymap.set('n', key, function()
      if vim.api.nvim_win_is_valid(help_window) then
        vim.api.nvim_win_close(help_window, true)
      end
    end, { buffer = buffer, silent = true, desc = 'Close quick help' })
  end
  local resize = vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
      if vim.api.nvim_win_is_valid(help_window) then
        vim.api.nvim_win_set_config(help_window, dimensions())
      end
    end,
  })
  vim.api.nvim_create_autocmd('BufWipeout', {
    buffer = buffer,
    once = true,
    callback = function()
      vim.api.nvim_del_autocmd(resize)
    end,
  })
end

return M
