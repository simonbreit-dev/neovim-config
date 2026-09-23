local languages = require 'config.languages'

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      local ts = require 'nvim-treesitter'
      ts.setup()
      vim.treesitter.language.register('yaml', 'yaml.ghactions')

      local function start(bufnr)
        if not vim.api.nvim_buf_is_loaded(bufnr) or vim.bo[bufnr].buftype ~= '' then
          return
        end
        local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
        if lang and pcall(vim.treesitter.start, bufnr, lang) then
          -- Indentation is experimental and not supplied for every parser.
          if vim.treesitter.query.get(lang, 'indents') then
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('user-treesitter-start', { clear = true }),
        callback = function(event)
          start(event.buf)
        end,
      })

      local installed = ts.get_installed 'parsers'
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, languages.treesitter)
      if #missing > 0 then
        if vim.fn.executable 'tree-sitter' == 0 then
          vim.notify('Parser installation requires tree-sitter CLI >= 0.26.1; check :checkhealth user.', vim.log.levels.WARN)
          return
        end
        ts.install(missing):await(vim.schedule_wrap(function(err, success)
          if err or not success then
            vim.notify('Some Treesitter parsers could not be installed; see :TSLog.', vim.log.levels.WARN)
          end
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            start(bufnr)
          end
        end))
      end
    end,
  },
}
