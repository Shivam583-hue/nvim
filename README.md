# Neovim config

A personal Neovim setup built on [NvChad](https://nvchad.com) (v2.5) with [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and [blink.cmp](https://github.com/Saghen/blink.cmp) for completion.
It supports C/C++ (including competitive-programming workflows), Go, Rust, Python, TypeScript/JavaScript, HTML/CSS, Elixir, Nix, and Typst, with LSP, formatting, treesitter highlighting, and debugging (nvim-dap) wired up per language.

## Prerequisites

These are required regardless of platform.
OS-specific install commands are in the Fedora and macOS sections below.

- **Neovim 0.10+** (0.11 recommended) - this config uses `vim.lsp.config`/`vim.lsp.enable`, which need a recent Neovim.
- **git** - to clone this repo and for `lazy.nvim` to bootstrap itself and every plugin.
- **A C compiler** (gcc or clang) plus `make` - treesitter compiles parsers from source on your machine.
- **curl** (or wget), **unzip**, **tar** - `mason.nvim` uses these to download and unpack language servers/formatters.
- **A Nerd Font** - icons in the statusline, file tree, completion menu, etc. all depend on one. This config's GUI font is set to `JetBrains Mono Nerd Font` (see `lua/options.lua`), so install that one unless you plan to change it.
- **ripgrep** - powers Telescope's live grep.
- **fd** - speeds up Telescope's file finder (falls back to `find` if missing).
- **Node.js + npm** - required by several Mason-managed servers (`css-lsp`, `html-lsp`, `htmx-lsp`, `eslint-lsp`, `prettier`, `prettierd`) and by `typescript-tools.nvim`. Also run `npm install -g typescript` once, since `typescript-tools.nvim` expects a global TypeScript install.
- **Go toolchain** - `gopls` and the extra Go tools that `go.nvim` installs on first run (`go.install().update_all_sync()`) both need `go` on your `PATH`.
- **Rust toolchain (via rustup)** - gives you `cargo` and `rustfmt`, which the `rustfmt` formatter needs. `rust_analyzer` and `codelldb` themselves are downloaded prebuilt by Mason.
- **Erlang/OTP + Elixir** - required to run `elixir-ls` and `credo`, and for the `mix format` formatter used on `.ex`/`.heex` files.
- **clangd + clang-format** - the C/C++ LSP and formatter. These are **not** managed by Mason in this config, they must come from your system's LLVM/Clang install.
- **Python 3** - `pyright` and `ruff` run fine against system Python; no virtualenv is required for editing.

## Fedora (fresh machine)

```sh
# Base tools, compiler, clipboard, and misc CLI utilities Mason needs
sudo dnf install -y neovim git ripgrep fd-find gcc gcc-c++ make \
  curl unzip tar wl-clipboard xdg-utils

# Node.js (for css-lsp/html-lsp/htmx-lsp/eslint-lsp/prettier and typescript-tools.nvim)
sudo dnf install -y nodejs
npm install -g typescript

# Go (for gopls + go.nvim's bundled tools)
sudo dnf install -y golang

# Rust, via rustup (gives you cargo + rustfmt + component management)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Erlang + Elixir (for elixir-ls, credo, mix format)
sudo dnf install -y erlang elixir

# clangd + clang-format for C/C++
sudo dnf install -y clang clang-tools-extra
```

Check `nvim --version` afterwards; if Fedora's repo version is older than 0.10, grab a newer build from the [Neovim releases page](https://github.com/neovim/neovim/releases) or a COPR such as `dnf copr enable agriffis/neovim-nightly`.

Nerd Font (no dnf package for this, install manually):

```sh
mkdir -p ~/.local/share/fonts
curl -fLo /tmp/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -fv
```

Then set your terminal emulator's font to "JetBrainsMono Nerd Font".

## macOS (fresh machine)

Install Xcode Command Line Tools first (gives you `git` and a working `clang`), then [Homebrew](https://brew.sh) if you don't already have it.

```sh
xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Base tools
brew install neovim git ripgrep fd

# Node.js (for css-lsp/html-lsp/htmx-lsp/eslint-lsp/prettier and typescript-tools.nvim)
brew install node
npm install -g typescript

# Go (for gopls + go.nvim's bundled tools)
brew install go

# Rust, via rustup (gives you cargo + rustfmt + component management)
brew install rustup-init
rustup-init -y
source "$HOME/.cargo/env"

# Elixir (pulls in Erlang/OTP automatically)
brew install elixir

# LLVM, for clangd + clang-format (Apple's bundled clang doesn't ship clangd)
brew install llvm
```

Add LLVM's bin directory to your `PATH` (put this in `~/.zshrc`):

```sh
echo 'export PATH="$(brew --prefix llvm)/bin:$PATH"' >> ~/.zshrc
```

Nerd Font:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

(If Homebrew complains it can't find the cask, run `brew tap homebrew/cask-fonts` first; recent Homebrew versions no longer need this.)

Then set your terminal emulator's font to "JetBrainsMono Nerd Font Mono".

## First-time setup (both platforms)

1. Clone this repo to `~/.config/nvim` (back up any existing config first).
2. Launch `nvim`. `lazy.nvim` bootstraps itself and installs every plugin automatically on first run - wait for it to finish, then restart Neovim.
3. Mason does **not** auto-install its `ensure_installed` list on startup in this config, so install everything explicitly by running this inside Neovim:
   ```
   :MasonInstall lua-language-server stylua luacheck css-lsp html-lsp htmx-lsp prettier prettierd eslint-lsp eslint_d nil gopls templ elixir-ls credo codelldb tinymist pyright ruff
   ```
4. Treesitter parsers also need installing explicitly (the `nvim-treesitter` plugin here is pinned to the legacy `master` branch, so the newer `:TSInstallAll` command doesn't work - use `:TSInstall` with the full list instead):
   ```
   :TSInstall vim lua regex bash markdown markdown_inline c cpp html css javascript typescript tsx nix go gomod gowork gosum templ rust typst elixir heex python
   ```
5. Run `:checkhealth` and resolve anything it flags red.
6. Open a file in each language you care about and confirm the LSP attaches (`:LspInfo`) and format-on-save works (`:w` then check the diff, or `:ConformInfo`).

## Language support matrix

| Language        | LSP              | Formatter                          | Notes                                   |
|-----------------|------------------|-------------------------------------|------------------------------------------|
| C / C++         | clangd           | clang-format                        | CodeLLDB debugging; clangd/clang-format from system LLVM |
| Go              | gopls            | goimports, gofumpt                  | extra tools installed by go.nvim on first use |
| Rust            | rust_analyzer    | rustfmt                             | codelldb for debugging |
| Python          | pyright, ruff    | ruff (format + import sort)         | ruff also supplies linting via LSP diagnostics |
| TypeScript/JS   | typescript-tools, eslint | prettierd                    | needs global `npm install -g typescript` |
| HTML/CSS        | html, htmx       | prettierd                           | |
| JSON/Markdown   | -                | prettierd                           | |
| Nix             | nil_ls           | alejandra                           | alejandra isn't in the Mason list; install separately (e.g. `nix profile install nixpkgs#alejandra`) if you edit Nix files |
| Elixir/HEEx     | elixirls, credo  | mix format                          | needs system Erlang/Elixir |
| Typst           | tinymist         | -                                    | |
| Lua             | lua-language-server | stylua                          | luacheck for linting |

## Debugging a C++ file

The C++ debugger uses `nvim-dap` with CodeLLDB. Open a `.cpp` file, then:

1. Move to a line where you want execution to pause and press `Space d b` to set a breakpoint.
2. Press `Space d c`. Neovim saves the file, builds it with debug information, and starts it.
3. When execution pauses, inspect variables in the debugger UI and use:
   - `Space d o` to run the current line without entering a called function.
   - `Space d i` to enter a function called on the current line.
   - `Space d O` to finish the current function and return to its caller.
   - `Space d e` to inspect the expression under the cursor or the selected expression.
   - `Space d c` to continue to the next breakpoint.
4. Press `Space d t` to stop, or `Space d u` to show or hide the debugger UI.

Program input and output use an integrated terminal. The automatic build is intended for
single-file C++ programs; projects with multiple source files should provide their own
`.vscode/launch.json` and build the executable before starting DAP.

## Optional integrations

- **Supermaven** (AI completion) - run `:SupermavenUseFree` (or log in) the first time you want it active.
- **WakaTime** (`vim-wakatime`) - drop an API key into `~/.wakatime.cfg`, otherwise the plugin is a harmless no-op.
- **Discord Rich Presence** (`presence.nvim`) - just needs the Discord desktop app running; nothing to configure.
- **Neovide** - `lua/neovide.lua` only takes effect if you're running the separate [Neovide](https://neovide.dev) GUI app instead of a terminal.

## Updating

Run `:Lazy sync` to update plugins, then `:MasonUpdate` to update installed language servers/formatters.
