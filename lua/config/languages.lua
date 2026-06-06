local M = {}

M.treesitter = {
  'bash',
  'css',
  'diff',
  'dockerfile',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'html',
  'java',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'scss',
  'svelte',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

M.lsp = {
  lua_ls = {
    mason = 'lua-language-server',
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false },
      },
    },
  },
  vtsls = {
    mason = 'vtsls',
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        experimental = { completion = { enableServerSideFuzzyMatch = true } },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = { completeFunctionCalls = true },
      },
    },
  },
  svelte = { mason = 'svelte-language-server' },
  html = { mason = 'html-lsp' },
  cssls = { mason = 'css-lsp' },
  jsonls = { mason = 'json-lsp' },
  yamlls = {
    mason = 'yaml-language-server',
    settings = {
      yaml = {
        keyOrdering = false,
        schemas = {
          ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
          ['https://json.schemastore.org/gitlab-ci.json'] = { '/*.gitlab-ci.yml', '/*.gitlab-ci.yaml' },
        },
      },
    },
  },
  dockerls = { mason = 'dockerfile-language-server' },
  docker_compose_language_service = { mason = 'docker-compose-language-service' },
  bashls = { mason = 'bash-language-server' },
  taplo = { mason = 'taplo' },
  lemminx = { mason = 'lemminx' },
  marksman = { mason = 'marksman' },
  gopls = {
    mason = 'gopls',
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        analyses = { unusedparams = true, unusedwrite = true },
      },
    },
  },
  pyright = {
    mason = 'pyright',
    settings = {
      python = { analysis = { typeCheckingMode = 'basic' } },
    },
  },
  ruff = { mason = 'ruff' },
  jdtls = {
    mason = 'jdtls',
    filetypes = { 'java' },
    condition = function()
      return vim.fn.executable 'java' == 1 and vim.fn.executable 'javac' == 1
    end,
  },
}

M.mason_tools = {
  'black',
  'eslint_d',
  'goimports',
  'google-java-format',
  'hadolint',
  'markdownlint-cli2',
  'prettier',
  'prettierd',
  'ruff',
  'shellcheck',
  'shfmt',
  'stylua',
  'yamllint',
}

local prettier = { 'prettierd', 'prettier', stop_after_first = true }

M.formatters_by_ft = {
  lua = { 'stylua' },
  java = { 'google-java-format' },
  sh = { 'shfmt' },
  bash = { 'shfmt' },
  zsh = { 'shfmt' },
  go = { 'goimports', 'gofmt', stop_after_first = true },
  python = { 'ruff_format', 'black', stop_after_first = true },
  javascript = prettier,
  javascriptreact = prettier,
  typescript = prettier,
  typescriptreact = prettier,
  svelte = prettier,
  html = prettier,
  css = prettier,
  scss = prettier,
  json = prettier,
  jsonc = prettier,
  yaml = prettier,
  ['yaml.gitlab'] = prettier,
  markdown = prettier,
  ['markdown.mdx'] = prettier,
  toml = { 'taplo' },
  xml = { 'xmllint' },
}

M.linters_by_ft = {
  javascript = { 'eslint_d', 'eslint' },
  javascriptreact = { 'eslint_d', 'eslint' },
  typescript = { 'eslint_d', 'eslint' },
  typescriptreact = { 'eslint_d', 'eslint' },
  svelte = { 'eslint_d', 'eslint' },
  yaml = { 'yamllint' },
  ['yaml.gitlab'] = { 'yamllint' },
  markdown = { 'markdownlint-cli2', 'markdownlint' },
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
  zsh = { 'shellcheck' },
  dockerfile = { 'hadolint' },
  python = { 'ruff' },
}

function M.mason_ensure_installed()
  local seen = {}
  local tools = {}

  local function add(tool)
    if tool and not seen[tool] then
      seen[tool] = true
      table.insert(tools, tool)
    end
  end

  for _, tool in ipairs(M.mason_tools) do
    add(tool)
  end

  for _, server in pairs(M.lsp) do
    add(server.mason)
  end

  table.sort(tools)
  return tools
end

return M
