# Personal Neovim Configuration

A modular Neovim setup for local macOS/Ghostty work and remote Linux editing over SSH. The configuration targets Neovim 0.11+ and uses modern native LSP APIs through `vim.lsp.config()` and `vim.lsp.enable()`.

## Supported Environments

- macOS with Ghostty
- Remote Linux servers over SSH
- Ubuntu 24.04 aarch64
- Shared Git checkout at `~/.config/nvim`
- Neovim 0.11 minimum, 0.12+ preferred

## Layout

- `init.lua`: small bootstrap only
- `lua/core/`: version check, options, clipboard, keymaps, autocmds, lazy.nvim bootstrap
- `lua/config/languages.lua`: central language/tool registry
- `lua/plugins/`: plugin specs grouped by responsibility
- `lua/user/health.lua`: custom `:checkhealth user`

## Install

Install base tools:

```sh
brew install neovim git ripgrep fd node python go openjdk
```

On Ubuntu:

```sh
sudo apt update
sudo apt install -y curl git ripgrep fd-find build-essential unzip nodejs npm python3 python3-venv openjdk-21-jdk
```

Clone this repository:

```sh
git clone <repo-url> ~/.config/nvim
```

Start Neovim:

```sh
nvim
```

Then run:

```vim
:Lazy sync
:Mason
:checkhealth
:checkhealth user
```

## Ubuntu 24.04 aarch64 Neovim

The Ubuntu package may lag behind this config's target version. Use the official ARM64 tarball:

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim-linux-arm64
sudo mkdir -p /opt/nvim-linux-arm64
sudo tar -C /opt/nvim-linux-arm64 --strip-components=1 -xzf nvim-linux-arm64.tar.gz
sudo ln -sf /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
nvim --version
```

## Language Support

Language behavior is centralized in `lua/config/languages.lua`.

| Area | LSP | Formatting | Linting |
| --- | --- | --- | --- |
| Lua | `lua_ls` | `stylua` | LSP diagnostics |
| Java | `jdtls` when Java/Javac exist | `google-java-format` | LSP diagnostics |
| JavaScript/TypeScript | `vtsls` | `prettierd`, `prettier` | `eslint_d`, `eslint` |
| Svelte | `svelte` | `prettierd`, `prettier` | `eslint_d`, `eslint` |
| HTML/CSS/SCSS | `html`, `cssls` | `prettierd`, `prettier` | LSP diagnostics |
| JSON/JSONC | `jsonls` | `prettierd`, `prettier` | LSP diagnostics |
| YAML/GitLab CI | `yamlls` | `prettierd`, `prettier` | `yamllint` |
| Markdown | `marksman` | `prettierd`, `prettier` | `markdownlint-cli2`, `markdownlint` |
| Bash/Zsh | `bashls` | `shfmt` | `shellcheck` |
| Dockerfile/Compose | `dockerls`, Compose LS | LSP diagnostics | `hadolint`, LSP diagnostics |
| TOML | `taplo` | `taplo` | LSP diagnostics |
| XML | `lemminx` | `xmllint` if available | LSP diagnostics |
| Go | `gopls` | `goimports`, `gofmt` | LSP diagnostics |
| Python | `pyright`, `ruff` | `ruff_format`, `black` | `ruff` |

Treesitter parsers are installed for the same language set where useful.

## Formatting

Formatting is handled by `conform.nvim`.

- Format on save is enabled by default.
- Toggle per buffer with `<leader>tf`.
- Format manually with `<leader>cf`.
- Missing formatters are ignored instead of crashing startup.

Global disable:

```vim
:lua vim.g.format_on_save = false
```

## Linting

Linting is handled by `nvim-lint`.

- Linting runs on read, write, and insert leave.
- Missing linter executables are filtered out at startup.
- Run manually with `<leader>cl`.
- Toggle event-based linting with `<leader>tl`.

## LSP

Servers are configured with Neovim's native 0.11+ APIs. `nvim-lspconfig` is used for server definitions, not for deprecated `require('lspconfig').SERVER.setup()` calls.

Completion capabilities come from `blink.cmp`.

Useful LSP mappings:

- `grd`: definition
- `grr`: references
- `gri`: implementation
- `grt`: type definition
- `grn`: rename
- `gra`: code action
- `K`: hover
- `<leader>th`: toggle inlay hints when supported

## Java Notes

Java support uses `jdtls` directly through native LSP config. It is only enabled when both `java` and `javac` are available, so servers without a JDK can still start Neovim normally.

Install a JDK before working on Java:

```sh
java -version
javac -version
```

JDK 21 is a good default for current Java work. Mason installs the `jdtls` package, and `google-java-format` is used for formatting.

## Clipboard and OSC52

Local macOS sessions use the normal system clipboard. SSH sessions are detected with `SSH_TTY` or `SSH_CONNECTION`; in those sessions the config sets:

```lua
vim.g.clipboard = 'osc52'
vim.o.clipboard = 'unnamedplus'
```

This lets yanks travel from a remote Neovim session to the local terminal clipboard when the terminal path allows OSC52.

Ghostty supports OSC52. If tmux is in the path, ensure tmux allows clipboard passthrough:

```tmux
set -g set-clipboard on
set -g allow-passthrough on
```

Test inside SSH:

```vim
:let @+ = 'osc52-test'
```

Then paste locally. If it does not work, test without tmux first, then check Ghostty and tmux clipboard settings.

## Plugin Decisions

Kept:

- `telescope.nvim` for fuzzy finding
- `gitsigns.nvim`, `vim-fugitive`, `diffview.nvim` for Git
- `blink.cmp` and `LuaSnip` for completion/snippets
- `conform.nvim` for formatting
- `nvim-lint` for linting
- `nvim-treesitter` for syntax
- `trouble.nvim` for diagnostics UI
- `mini.files`, `mini.ai`, `mini.surround` for focused editor features
- `Comment.nvim`, `nvim-autopairs`, `todo-comments.nvim`
- `tokyonight.nvim`, `mini.statusline`

Removed:

- Kickstart tutorial docs and example modules
- DAP example stack, because it was unused tutorial code and not production-ready
- Duplicate Git/lint/plugin declarations
- Empty npm lockfile
- Extra theme plugins that were installed but inactive
- `cutlass.nvim`, because changing delete semantics globally is a personal editing policy rather than a core production requirement
- `vim-alloy`, because it is niche and should be re-added only if Alloy files are actively edited

## Maintenance

Update plugins:

```vim
:Lazy sync
```

Review installed tools:

```vim
:Mason
```

Run health checks:

```vim
:checkhealth
:checkhealth user
```

Format Lua:

```sh
stylua .
```

Check Lua syntax without starting the UI:

```sh
nvim --headless "+lua print('ok')" +qa
```

## Troubleshooting

If Neovim fails before plugins load, check the version:

```sh
nvim --version
```

If a language server is missing, open `:Mason` and install or repair the relevant package.

If formatting does nothing, run `:ConformInfo` in the buffer.

If linting does nothing, verify the executable is on `PATH`:

```sh
eslint_d --version
shellcheck --version
yamllint --version
ruff --version
```

If Java LSP does not start, verify a JDK is installed and visible to the remote shell running Neovim.
