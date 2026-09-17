# Personal Neovim Configuration

This is my personal Neovim configuration, it was initially forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). I use it on macOS/Ghostty and remote Linux machines over SSH. Feel free to borrow parts and adapt them to your workflow.

Built around lazy.nvim, native LSP, blink.cmp/LuaSnip, Telescope, conform.nvim, nvim-lint, Treesitter, mini.nvim, Trouble, and Git tools, with Tokyonight Night.

## Requirements and installation

- **Neovim 0.12+** for the pinned Treesitter revision; the startup guard only enforces 0.11+.
- Git, curl, tar, unzip, make, and a C compiler.
- ripgrep for live grep; fd recommended for file searches (`fd-find` on Ubuntu).
- Language runtimes as needed: Node.js/npm, Python 3 with venv support, Go, a JDK. Java LSP requires both `java` and `javac` on `PATH`.
- tree-sitter CLI 0.26.1+ from a package manager, not npm; see [Treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/4916d6592ede8c07973490d9322f187e07dfefac/README.md#requirements).
- A Nerd Font, or set `vim.g.have_nerd_font = false` in `lua/core/globals.lua`.

Install Neovim via a package manager or [official releases](https://github.com/neovim/neovim/releases). Ubuntu 24.04 packages may be too old; choose ARM64 releases for aarch64.

Back up any existing config, then clone (requires GitHub SSH access):

```sh
git clone git@github.com:simonbreit-dev/neovim-config.git ~/.config/nvim
nvim
```

lazy.nvim installs itself and plugins on first launch. Run `:Lazy restore` for the committed revisions. Open a source file to trigger Mason's tool installation, then review `:Mason`, `:checkhealth`, and `:checkhealth user`.

Parser installation currently needs an explicit step:

```vim
:lua require('nvim-treesitter').install(require('config.languages').treesitter)
```

Wait for installation, then restart. See the Treesitter caveat below.

## Layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Loads the core modules |
| `lua/core/` | Version check, options, clipboard, keymaps, autocmds, lazy.nvim |
| `lua/config/languages.lua` | LSP settings, Mason tools, formatter/linter mappings, parser list |
| `lua/plugins/` | Plugin specs grouped by responsibility |
| `lua/user/health.lua` | Custom `:checkhealth user` checks |
| `lazy-lock.json` | Committed plugin revisions |

## Languages

`lua/config/languages.lua` declares servers and tools for Mason. Project configuration and runtimes must be available separately.

| Language | LSP | Formatter preference | External linting |
| --- | --- | --- | --- |
| Lua | `lua_ls` | StyLua | — |
| Java | `jdtls` (requires a JDK) | google-java-format | — |
| JavaScript/TypeScript | `vtsls` | prettierd → prettier | eslint_d, eslint |
| Svelte | `svelte` | prettierd → prettier | eslint_d, eslint |
| HTML/CSS/SCSS | `html`, `cssls` | prettierd → prettier | — |
| JSON/JSONC | `jsonls` | prettierd → prettier | — |
| YAML/GitLab CI | `yamlls` | prettierd → prettier | yamllint |
| Markdown | `marksman` | prettierd → prettier | markdownlint-cli2, markdownlint |
| Shell | `bashls` | shfmt | shellcheck |
| Dockerfile/Compose | `dockerls`, `docker_compose_language_service` | LSP fallback if supported | hadolint (Dockerfile) |
| TOML | `taplo` | taplo | — |
| XML | `lemminx` | xmllint (install separately) | — |
| Go | `gopls` | goimports → gofmt | — |
| Python | `pyright`, `ruff` | ruff_format → black | ruff |

Arrows select the first available formatter. All available external linters run alongside LSP diagnostics; availability is checked at plugin load. Zsh mappings exist, but bashls/shellcheck do not fully support Zsh.

## Everyday use

Leader/local leader: **Space**. Browse mappings with `:Telescope keymaps` or which-key.

| Key / command | Action |
| --- | --- |
| `<leader>sf`, `<leader>sg`, `<leader><leader>` | Find files, live grep, switch buffers |
| `<leader>e` | mini.files explorer |
| `<leader>cf` | Format buffer or selection |
| `<leader>tf`, `<leader>tl` | Toggle buffer format-on-save / global linting |
| `grd`, `grr`, `gri`, `grt` | LSP definition, references, implementation, type definition |
| `grn`, `gra`, `K`, `<leader>th` | Rename, code action, hover, toggle supported inlay hints |
| `<leader>gg`, `<leader>gv`, `<leader>gh` | Git status, diff view, current file history |
| `]c`, `[c`, `<leader>gp` | Next/previous Git hunk, preview hunk |
| `<leader>xx`, `<leader>xX` | Trouble diagnostics / current buffer diagnostics |
| `:ConformInfo`, `:Mason` | Inspect formatting / installed language tools |

Formatting runs on save by default, except for C/C++, with LSP formatting as a fallback. Disable it globally with `:lua vim.g.format_on_save = false`, or for the current buffer with `:lua vim.b.format_on_save = false`.

Linting runs on buffer read, write, and insert leave. `:lua vim.g.lint_on_events = false` disables it, including the current manual lint callback. Restart Neovim after installing a previously missing linter so it is picked up.

## Clipboard over SSH

Local sessions use `unnamedplus`. With `SSH_TTY` or `SSH_CONNECTION`, OSC52 copies to the local clipboard through the terminal. Remote paste depends on terminal policy.

tmux may need:

```tmux
set -g set-clipboard on
set -g allow-passthrough on
```

Test with `:let @+ = 'osc52-test'`, then paste locally. If it fails, try without tmux and check terminal settings.

## Current caveats

- **Treesitter:** the `main` spec does not install its parser list: `ensure_installed` is unused. Install explicitly as above. Upstream [does not support lazy loading](https://github.com/nvim-treesitter/nvim-treesitter/blob/4916d6592ede8c07973490d9322f187e07dfefac/README.md#installation), but this spec uses buffer events; first-buffer highlighting may be unreliable.
- **Format toggle:** with an unset buffer setting, the first `<leader>tf` press keeps formatting enabled. Press again or use the explicit setting above.
- **Mapping collision:** `<leader>cl` means Trouble LSP or manual lint, depending on load order. Use `:Trouble lsp toggle` or `:lua require('lint').try_lint()` explicitly.

## Maintenance

Update plugins with `:Lazy sync`, review `lazy-lock.json`, or restore with `:Lazy restore`. Update installed parsers with `:TSUpdate`. Review `:Mason` and health checks after dependency changes.

Check Lua with `stylua --check .`; format with `stylua .` using `.stylua.toml`. CI checks pull requests and pushes to `main`; direct pushes to the current default branch, `master`, are not checked.

## License

[MIT](LICENSE.md), as in the original kickstart.nvim project.
