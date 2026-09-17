# Personal Neovim Configuration

This is my personal Neovim configuration, it was initially forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). I use it on macOS/Ghostty and remote Linux machines over SSH. Feel free to borrow parts and adapt them to your workflow.

Built around lazy.nvim, native LSP, blink.cmp/LuaSnip, Telescope, conform.nvim, nvim-lint, Treesitter, mini.nvim, Trouble, and Git tools, with Tokyonight Night.

## Requirements and installation

- **Neovim 0.12+**, enforced at startup and checked by the custom health check.
- Git, curl, tar, unzip, make, and a C compiler.
- ripgrep for live grep; fd recommended for file searches (`fd-find` on Ubuntu).
- Language runtimes as needed: Node.js/npm, Python 3 with venv support, Go, a JDK, and the .NET SDK. Current csharp-ls needs .NET 10; Java LSP needs JDK 21+ with `java` and `javac` available.
- tree-sitter CLI 0.26.1+ from a package manager, not npm; see [Treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/4916d6592ede8c07973490d9322f187e07dfefac/README.md#requirements).
- A Nerd Font, or set `vim.g.have_nerd_font = false` in `lua/core/globals.lua`.

Install Neovim via a package manager or [official releases](https://github.com/neovim/neovim/releases). Ubuntu 24.04 packages may be too old; choose ARM64 releases for aarch64.

Back up any existing config, then clone (requires GitHub SSH access):

```sh
git clone git@github.com:simonbreit-dev/neovim-config.git ~/.config/nvim
nvim
```

lazy.nvim installs itself and plugins on first launch. Run `:Lazy restore` for the committed revisions. Mason installs configured tools even when starting without a file. Treesitter loads at startup and installs missing parsers asynchronously; highlighting starts in open buffers when installation finishes. Allow installation to finish before closing Neovim, then review `:Mason`, `:checkhealth`, and `:checkhealth user`.

On macOS, the config discovers Homebrew's keg-only JDK and repairs a missing/stale `DOTNET_ROOT` from the installed dotnet runtime. Explicit valid runtime paths remain authoritative.

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
| C# | `csharp_ls` | LSP formatting (`.editorconfig`) | Roslyn/compiler diagnostics via LSP |
| Java | `jdtls` (requires a JDK) | google-java-format | — |
| JavaScript/TypeScript | `vtsls` | prettierd → prettier | project eslint → eslint_d |
| Svelte/SvelteKit | `svelte`, TypeScript Svelte plugin for JS/TS | Prettier with Svelte plugin | project eslint → eslint_d |
| HTML | `html` | prettierd → prettier | HTMLHint |
| CSS/SCSS | `cssls` | prettierd → prettier | CSS validation via LSP |
| JSON/JSONC | `jsonls` | prettierd → prettier | — |
| YAML/GitLab CI | `yamlls` | prettierd → prettier | yamllint |
| Markdown | `marksman` | prettierd → prettier | markdownlint-cli2, markdownlint |
| Shell | `bashls` | shfmt | shellcheck |
| Dockerfile/Compose | `dockerls`, `docker_compose_language_service` | Prettier for Compose; LSP fallback otherwise | hadolint (Dockerfile) |
| TOML | `taplo` | taplo | — |
| XML | `lemminx` | xmllint (install separately) | — |
| Go | `gopls` | goimports, then gofumpt | staticcheck/compiler diagnostics via LSP |
| Python | `pyright`, `ruff` | ruff_format → black | Ruff via LSP |

Arrows select the first available tool. External linter alternatives run once per buffer, with availability checked on each invocation. LSP diagnostics provide type checking, compiler errors, and schema validation alongside external linting. Ruff diagnostics come exclusively from its LSP server. Bash uses ShellCheck; Zsh is not passed to bashls, ShellCheck, or shfmt because they do not support Zsh syntax.

Java and C# need recognizable Maven/Gradle or solution/project files for full project diagnostics. Restore .NET dependencies (`dotnet restore`) when necessary. JSON and YAML validation uses language-server schemas; HTMLHint supplies HTML checks and cssls validates CSS.

JS/TS and Svelte linting requires a project ESLint configuration and its dependencies. Flat configurations are supported, including Svelte parser/plugin configuration from the project. Prettier uses project versions and settings where available. For Svelte formatting and TS integration, project Svelte plugins take precedence over the copies bundled with Mason's Svelte language server. Generate SvelteKit types (`npx svelte-kit sync`, usually run by the project's prepare script) before expecting route and `$types` diagnostics.

## Everyday use

Leader/local leader: **Space**. Press **Space** in normal mode and pause for the which-key shortcut menu. **Space → s → k** searches keymaps; **Space → s → h** searches Neovim help.

Press **F1** or **Space → ?**, or run `:QuickHelp`, for a scrollable editing guide covering selection, yank/copy, paste, cut, delete, undo, and formatting. F1 also works while typing or selecting. Close the guide with **q**, **Esc**, or **F1**; scroll with **j/k** or **Ctrl-d/u**.

| Key / command | Action |
| --- | --- |
| `F1`, `<leader>?`, `:QuickHelp` | Quick editing guide |
| `J`, `K` in visual mode | Move selected lines down / up, keeping the selection |
| `<leader>cp`, `<leader>cP` | Copy absolute file path / path with current line |
| `<leader>tw`, `<leader>tn`, `<leader>td` | Toggle window wrap / relative numbers / global inline diagnostic text |
| `<leader>sf`, `<leader>sg`, `<leader><leader>` | Find files, live grep, switch buffers |
| `<leader>e` | mini.files explorer |
| `<leader>cf` | Format buffer or selection |
| `<leader>tf`, `<leader>tl` | Toggle buffer format-on-save / global linting |
| `<leader>cl`, `<leader>cL` | Manual external lint / Trouble LSP references |
| `grd`, `grr`, `gri`, `grt` | LSP definition, references, implementation, type definition |
| `grn`, `gra`, `K`, `<leader>th` | Rename, code action, hover, toggle supported inlay hints |
| `<leader>gg`, `<leader>gv`, `<leader>gh` | Git status, diff view, current file history |
| `]c`, `[c`, `<leader>gp` | Next/previous Git hunk, preview hunk |
| `<leader>xx`, `<leader>xX` | Trouble diagnostics / current buffer diagnostics |
| `:ConformInfo`, `:Mason` | Inspect formatting / installed language tools |

Formatting runs on save by default, except for C/C++, with LSP formatting as a fallback. Disable it globally with `:lua vim.g.format_on_save = false`, or for the current buffer with `:lua vim.b.format_on_save = false`.

External linting runs on buffer read, write, and insert leave, with a short debounce. `:lua vim.g.lint_on_events = false` disables automatic external linting; manual `<leader>cl` still works. LSP diagnostics stay active. Newly installed linters are picked up without restarting, and linting uses the buffer's project directory even if Neovim was launched elsewhere.

Files reopen at their saved cursor position, except Git commit/rebase messages, hex views, and diff windows. Moving a selection with uppercase `J`/`K` reindents it; lowercase `j`/`k` still extends the selection. Counts such as `3J` move multiple lines. Inline diagnostic text can be hidden while retaining signs, underlines, and diagnostic lists.

Find with `/text` and jump between matches with `n`/`N`. Replace throughout a file with `:%s/old/new/gc`; `c` asks before each replacement and the existing live preview shows the changes. For selected lines, select them, press `:`, then type `s/old/new/gc` (the range is inserted automatically). To restrict where matches start to the selection, use `s/\%Vold/new/gc` instead. Patterns are regular expressions. The quick guide includes these examples and commonly used navigation, comment, and Git shortcuts.

## Clipboard over SSH

Local sessions use `unnamedplus`. With `SSH_TTY` or `SSH_CONNECTION`, OSC52 copies to the local clipboard through the terminal. Remote paste depends on terminal policy.

tmux may need:

```tmux
set -g set-clipboard on
set -g allow-passthrough on
```

Test with `:let @+ = 'osc52-test'`, then paste locally. If it fails, try without tmux and check terminal settings.

## Maintenance

Update plugins with `:Lazy sync`, review `lazy-lock.json`, or restore with `:Lazy restore`. Update installed parsers with `:TSUpdate`. Review `:Mason` and health checks after dependency changes.

Check Lua with `stylua --check .`; format with `stylua .` using `.stylua.toml`. Run `nvim --headless -u NONE -l tests/smoke.lua` for regression checks using installed plugins. These checks isolate automatic installation and server startup; they do not replace project-specific language-server testing. CI runs formatting and regression checks for pull requests and pushes to `main` and `master`.

See [language validation](tests/VALIDATION.md) for the actual highlighting, formatting, and diagnostic checks completed for the supported languages.

## License

[MIT](LICENSE.md), as in the original kickstart.nvim project.
