local languages = require 'config.languages'

local function supports(client, method, bufnr)
  if not client then
    return false
  end
  if client.supports_method then
    return client:supports_method(method, bufnr)
  end
  return client.server_capabilities and client.server_capabilities[method]
end

local function setup_lsp_attach()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      local telescope_ok, builtin = pcall(require, 'telescope.builtin')
      map('grn', vim.lsp.buf.rename, 'Rename')
      map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, 'Declaration')
      map('K', vim.lsp.buf.hover, 'Hover')

      if telescope_ok then
        map('grr', builtin.lsp_references, 'References')
        map('gri', builtin.lsp_implementations, 'Implementation')
        map('grd', builtin.lsp_definitions, 'Definition')
        map('grt', builtin.lsp_type_definitions, 'Type definition')
        map('gO', builtin.lsp_document_symbols, 'Document symbols')
        map('gW', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
      else
        map('grr', vim.lsp.buf.references, 'References')
        map('grd', vim.lsp.buf.definition, 'Definition')
        map('grt', vim.lsp.buf.type_definition, 'Type definition')
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local group = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = group,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
          buffer = event.buf,
          group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = false }),
          callback = function(detach_event)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = group, buffer = detach_event.buf }
          end,
        })
      end

      if supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
        end, 'Toggle inlay hints')
      end
    end,
  })
end

local function configure_diagnostics()
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = true,
    virtual_text = {
      source = 'if_many',
      spacing = 2,
    },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
  }
end

local function lsp_capabilities()
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then
    return blink.get_lsp_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

local function configure_servers()
  local capabilities = lsp_capabilities()

  for name, config in pairs(languages.lsp) do
    if not config.condition or config.condition() then
      local server_config = vim.tbl_deep_extend('force', {}, config)
      server_config.mason = nil
      server_config.condition = nil
      server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})

      local ok, err = pcall(vim.lsp.config, name, server_config)
      if ok then
        pcall(vim.lsp.enable, name)
      else
        vim.schedule(function()
          vim.notify(('Skipping LSP server %s: %s'):format(name, err), vim.log.levels.WARN)
        end)
      end
    end
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = { ui = { border = 'rounded' } } },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      setup_lsp_attach()
      configure_diagnostics()
      configure_servers()

      local ok, installer = pcall(require, 'mason-tool-installer')
      if ok then
        installer.setup {
          ensure_installed = languages.mason_ensure_installed(),
          auto_update = false,
          run_on_start = true,
          start_delay = 3000,
        }
      end
    end,
  },
}
