local M = {}

M.treesitter = {
  'bash',
  'c_sharp',
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
  csharp_ls = {
    mason = 'csharp-language-server',
    settings = { csharp = { analyzersEnabled = true } },
    condition = function()
      return vim.fn.executable 'dotnet' == 1
    end,
  },
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
    before_init = function(_, config)
      local _, root = require('user.node').svelte_package('typescript-svelte-plugin', config.root_dir)
      config.settings.vtsls.tsserver.globalPlugins = root
          and { { name = 'typescript-svelte-plugin', location = root, enableForWorkspaceTypeScriptVersions = true } }
        or {}
    end,
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        tsserver = {
          globalPlugins = {
            { name = 'typescript-svelte-plugin', enableForWorkspaceTypeScriptVersions = true },
          },
        },
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
  gh_actions_ls = {
    -- Mason's historical package name now installs the official @actions/languageserver.
    mason = 'gh-actions-language-server',
    cmd = { 'actions-languageserver', '--stdio' },
    filetypes = { 'yaml.ghactions' },
  },
  yamlls = {
    mason = 'yaml-language-server',
    settings = {
      yaml = {
        keyOrdering = false,
        schemas = {
          ['https://json.schemastore.org/gitlab-ci.json'] = { '/*.gitlab-ci.yml', '/*.gitlab-ci.yaml' },
        },
      },
    },
  },
  dockerls = { mason = 'dockerfile-language-server' },
  docker_compose_language_service = { mason = 'docker-compose-language-service' },
  bashls = {
    mason = 'bash-language-server',
    settings = { bashIde = { shellcheckPath = '' } },
  },
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
      pyright = { disableOrganizeImports = true },
      python = { analysis = { typeCheckingMode = 'basic' } },
    },
  },
  ruff = { mason = 'ruff' },
  jdtls = {
    mason = 'jdtls',
    filetypes = { 'java' },
    cmd = function(dispatchers, config)
      local root = config.root_dir or vim.uv.cwd()
      local workspace = vim.fs.joinpath(vim.fn.stdpath 'cache', 'jdtls', vim.fn.sha256(root):sub(1, 16))
      local cmd = { 'jdtls', '-data', workspace }
      for arg in (vim.env.JDTLS_JVM_ARGS or ''):gmatch '%S+' do
        table.insert(cmd, '--jvm-arg=' .. arg)
      end
      return vim.lsp.rpc.start(cmd, dispatchers, { cwd = config.cmd_cwd or root, env = config.cmd_env, detached = config.detached })
    end,
    condition = function()
      return vim.fn.executable 'java' == 1 and vim.fn.executable 'javac' == 1
    end,
  },
}

M.mason_tools = {
  'actionlint',
  'black',
  'eslint_d',
  'goimports',
  'gofumpt',
  'google-java-format',
  'hadolint',
  'htmlhint',
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
  go = { 'goimports', 'gofumpt' },
  python = { 'ruff_format', 'black', stop_after_first = true },
  javascript = prettier,
  javascriptreact = prettier,
  typescript = prettier,
  typescriptreact = prettier,
  svelte = { 'prettier_svelte' },
  html = prettier,
  css = prettier,
  scss = prettier,
  json = prettier,
  jsonc = prettier,
  yaml = prettier,
  ['yaml.ghactions'] = prettier,
  ['yaml.gitlab'] = prettier,
  markdown = prettier,
  ['markdown.mdx'] = prettier,
  toml = { 'taplo' },
  xml = { 'xmllint' },
}

M.linters_by_ft = {
  html = { 'htmlhint' },
  javascript = { 'eslint', 'eslint_d' },
  javascriptreact = { 'eslint', 'eslint_d' },
  typescript = { 'eslint', 'eslint_d' },
  typescriptreact = { 'eslint', 'eslint_d' },
  svelte = { 'eslint', 'eslint_d' },
  yaml = { 'yamllint' },
  ['yaml.ghactions'] = { 'actionlint' },
  ['yaml.gitlab'] = { 'yamllint' },
  markdown = { 'markdownlint-cli2', 'markdownlint' },
  sh = { 'shellcheck' },
  bash = { 'shellcheck' },
  dockerfile = { 'hadolint' },
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
