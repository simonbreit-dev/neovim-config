return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 250,
      icons = vim.g.have_nerd_font and {} or {
        mappings = false,
        keys = {
          Up = 'Up',
          Down = 'Down',
          Left = 'Left',
          Right = 'Right',
          C = 'Ctrl',
          M = 'Alt',
          D = 'Cmd',
          S = 'Shift',
          CR = 'Enter',
          Esc = 'Esc',
          ScrollWheelDown = 'ScrollDown',
          ScrollWheelUp = 'ScrollUp',
          NL = 'Enter',
          BS = 'Backspace',
          Space = 'Space',
          Tab = 'Tab',
          F1 = 'F1',
          F2 = 'F2',
          F3 = 'F3',
          F4 = 'F4',
          F5 = 'F5',
          F6 = 'F6',
          F7 = 'F7',
          F8 = 'F8',
          F9 = 'F9',
          F10 = 'F10',
          F11 = 'F11',
          F12 = 'F12',
        },
      },
      spec = {
        { '<leader>c', group = 'Code' },
        { '<leader>g', group = 'Git' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Toggle' },
        { '<leader>x', group = 'Diagnostics' },
      },
    },
  },
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {},
  },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = vim.g.have_nerd_font and {} or {
      icons = { indent = { fold_open = '- ', fold_closed = '+ ' }, folder_closed = '+ ', folder_open = '- ' },
      formatters = {
        kind_icon = function()
          return ''
        end,
        file_icon = function()
          return ''
        end,
      },
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Document symbols' },
      { '<leader>cL', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP references' },
    },
  },
}
