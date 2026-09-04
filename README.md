# dotfiles

Configuration files for my development environment across macOS and Linux.

## What's in here

### Terminal & Shell

- **[Fish Shell](https://fishshell.com)** — `fish/config.fish`
  - Hybrid vi/emacs key bindings (vi modes layered over emacs defaults)
  - Per-mode cursor shapes, greeting disabled
  - Abbreviations for Git, Docker, npm, and Homebrew workflows
  - [Zoxide](https://github.com/ajeetdsouza/zoxide) for smart directory jumping
  - [FZF](https://github.com/junegunn/fzf) for fuzzy finding

- **[Tmux](https://github.com/tmux/tmux)** — `.tmux.conf`
  - Prefix rebound to `C-a`
  - Mouse support, 300k line scrollback
  - New splits and windows inherit the current pane's directory
  - Minimal status bar
  - [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) for seamless pane navigation

### Editor

- **[Neovim](https://neovim.io)** — `nvim/`
  - Vendored copy of [quick.nvim](https://github.com/albingroen/quick.nvim) by [@albingroen](https://github.com/albingroen)
  - Plugins managed by **[lazy.nvim](https://github.com/folke/lazy.nvim)** — lazy-loaded and pinned in `nvim/lazy-lock.json`
  - Native LSP + [Mason](https://github.com/williamboman/mason.nvim) for server management
  - [Telescope](https://github.com/nvim-telescope/telescope.nvim) (Ivy theme) — fuzzy finding
  - [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — syntax highlighting
  - [blink.cmp](https://github.com/saghen/blink.cmp) — completion
  - [Conform](https://github.com/stevearc/conform.nvim) — format on save
  - [Oil](https://github.com/stevearc/oil.nvim) — file explorer (`-`)
  - [Gitsigns](https://github.com/lewis6991/gitsigns.nvim) — inline git
  - See `nvim/README.md` for the full key mapping reference.

### Terminal Emulator

- **[Ghostty](https://ghostty.org)** — `ghostty/config`
  - Fish shell integration, tab-style titlebar
  - Font size 15, adjusted cell and cursor height, non-blinking cursor
  - Automatic light/dark theme switching (Nvim Light / Nvim Dark)
  - `Cmd+Ctrl+T` global quick terminal toggle

### AI Assistant

- **[Crush](https://github.com/charmbracelet/crush)** — `crush/crushrc`
  - Config is Bash with Crush builtins (`provider`, `model`, `mcp`,
    `permissions`), executed at startup
  - Ships as a documented skeleton: permissions, providers and MCP servers are
    commented out rather than chosen for you
  - **No API keys are committed.** Crush reads them from the environment
    (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, …). Put them in
    `crush/crushrc.local`, which is gitignored and sourced automatically

### macOS

- **System defaults** — `macos/defaults.sh`
  - Fast key repeat: holding a key repeats it quickly instead of opening the
    accent picker (`ApplePressAndHoldEnabled` off, `KeyRepeat` 1,
    `InitialKeyRepeat` 10)

- **App preferences** — `macos/apps.sh` imports the committed plists
  - [Stats](https://github.com/exelban/stats) — menu bar system monitor
    (CPU, GPU, RAM, disk, network, battery, clock)
  - [Rectangle](https://rectangleapp.com) — window management
  - [DockDoor](https://github.com/ejbills/DockDoor) — dock hover window previews

- **Installed without committed settings** (Brewfile only)
  - [Raycast](https://raycast.com) — launcher and Spotlight replacement
  - [Postico](https://eggerapps.at/postico2/) — PostgreSQL client

## Structure

```
dotfiles/
├── fish/
│   └── config.fish           # Fish shell config and abbreviations
├── nvim/
│   ├── init.lua              # Plugin list and per-plugin setup
│   ├── lua/
│   │   └── basics.lua        # Core options and keymaps
│   ├── lazy-lock.json        # Pinned plugin revisions
│   └── README.md             # quick.nvim docs and key mappings
├── ghostty/
│   └── config                # Ghostty terminal config
├── crush/
│   └── crushrc               # Crush config (crushrc.local is gitignored)
├── macos/
│   ├── defaults.sh           # System defaults (key repeat)
│   ├── apps.sh               # Imports the app plists below
│   ├── Stats.plist
│   ├── Rectangle.plist
│   └── DockDoor.plist
├── .tmux.conf                # Tmux config
├── .luarc.json               # Lua LSP: declare `vim` as a global
├── Brewfile                  # Packages and casks these configs assume
└── install.sh                # Symlinks everything into place
```

## Prerequisites

Everything is listed in the [Brewfile](Brewfile):

```sh
brew bundle
```

Note **Neovim 0.11+** is required by lazy.nvim and the LSP config here.
`tree-sitter-cli` is a hard requirement, not a nicety — see Notes.

## Installation

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
brew bundle          # install packages and apps
./install.sh         # symlink configs, apply macOS defaults
./macos/apps.sh      # import Stats/Rectangle/DockDoor settings (macOS only)
```

`install.sh` symlinks each config into place and backs up anything already
there to `<path>.backup`. It does not install packages.

Then install tpm for tmux plugins:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and press `C-a I` to install plugins. Start Neovim and lazy.nvim
bootstraps itself, then installs every plugin and compiles the treesitter
parsers on first launch; run `:Mason` to install language servers, formatters,
and linters, and `:Lazy` to manage plugins.

## Reference

### Command-line tools

| Tool | What it does |
| --- | --- |
| [Fish Shell](https://fishshell.com) | User-friendly shell with autosuggestions, syntax highlighting, and sensible defaults out of the box. |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer for managing multiple sessions, windows, and panes from a single screen. |
| [Neovim](https://neovim.io) | Hyperextensible Vim-based text editor built for modern workflows and plugin ecosystems. |
| [fzf](https://github.com/junegunn/fzf) | Blazing-fast general-purpose fuzzy finder for files, commands, and anything piped to it. |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` that learns your most-used directories and jumps to them instantly. |

### Neovim plugins

Managed by lazy.nvim from the spec in `nvim/init.lua`, pinned in
`nvim/lazy-lock.json`. Most load on demand — only 6 of 23 load at startup.

| Plugin | What it does |
| --- | --- |
| [blink.cmp](https://github.com/saghen/blink.cmp) | High-performance completion plugin with fuzzy matching and async support. |
| [blink.lib](https://github.com/saghen/blink.lib) | Shared Lua library that blink.cmp depends on. |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Lightweight formatter plugin that runs formatters on save with minimal config. |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Collection of preconfigured snippets for a wide range of languages and frameworks. |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration that shows added, changed, and removed lines in the sign column. |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Portable package manager for LSP servers, linters, formatters, and DAP adapters. |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Bridge between Mason and lspconfig for automatic LSP server setup. |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Automatically closes brackets, quotes, and other paired characters as you type. |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Official quickstart configs for Neovim's built-in LSP client. |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Easily add, change, and delete surrounding pairs like quotes, brackets, and tags. |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Treesitter integration for better syntax highlighting, indentation, and code navigation. |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | Automatically closes and renames HTML/JSX tags using Treesitter. |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer that lets you edit your filesystem like a normal buffer. |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua utility library used as a dependency by many popular plugins. |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renders Markdown inline with headings, code blocks, and formatting styled in the buffer. |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Highly extensible fuzzy finder for files, grep results, LSP symbols, and more. |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Modern plugin manager with lazy-loading, lockfiles, and a clean UI. |
| [onedark.nvim](https://github.com/navarasu/onedark.nvim) | Atom-inspired One Dark colorscheme with multiple style variants. |
| [ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | Sets the correct comment style based on cursor location in embedded languages. |
| [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) | Native TypeScript language server integration, faster than tsserver wrappers. |
| [vim-sleuth](https://github.com/tpope/vim-sleuth) | Automatically detects and sets the correct indentation style for each file. |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless navigation between Neovim splits and tmux panes with the same keybindings. |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Displays a popup of available keybindings as you type, so you never forget a shortcut. |

### Deliberately not installed

| Plugin | Why not |
| --- | --- |
| nvim-ts-context-commentstring | Superseded by `ts-comments.nvim`, which is installed and does the same job. |
| vim-rhubarb | Only useful as a vim-fugitive extension, and fugitive is not installed. |

## Notes

- **Colorscheme** is onedark, set in the `navarasu/onedark.nvim` block of
  `nvim/init.lua`. Change `style` to one of `dark`, `darker`, `cool`, `deep`,
  `warm`, `warmer`, or `light`.
- **`tree-sitter-cli` is required**, not optional. nvim-treesitter's `main`
  branch shells out to it to compile parsers; without it every parser fails to
  build and syntax highlighting silently falls back to regex. Note the Homebrew
  formula is `tree-sitter-cli` — plain `tree-sitter` installs only the C
  library, with no binary.

- The committed app plists have machine-specific state stripped (window
  positions, update-checker timestamps, and a macOS bookmark blob that
  embedded a local path). Re-export with `defaults export <domain> -` and
  strip again if you update them.
- `crush/crushrc` runs as Bash at startup and is world-readable in this repo.
  Anything secret belongs in `crush/crushrc.local`, which is gitignored. Verify
  with `git check-ignore -v crush/crushrc.local` before adding keys.
- **Crush needs setup before first use, and has not been run yet.** It was
  added to the Brewfile and symlinked, but never installed or launched, so
  nothing here is verified against a running Crush. To finish:

  ```sh
  brew bundle                                    # installs crush via the tap
  echo 'export ANTHROPIC_API_KEY="sk-..."' >> ~/.config/crush/crushrc.local
  crush                                          # first launch
  ```

  Then decide on permissions — `crushrc` deliberately leaves
  `permissions allow ...` commented out, so Crush prompts for everything until
  you opt in. Uncomment `permissions allow view` for read-only auto-approval,
  or `permissions allow view edit` to include edits.
- There was never an OpenCode config in this repo. Crush was added alongside
  the existing tools, not swapped in for anything.
- `macos/apps.sh` uses `defaults import`, which **replaces** the whole
  preference domain — anything not in the committed plist resets to default.
  It exports whatever is already there to `~/.dotfiles-prefs-backup/<timestamp>/`
  first, so nothing is lost. Restore with
  `defaults import <domain> <backup>/<domain>.plist`.

## Credits

`nvim/` is a vendored copy of [quick.nvim](https://github.com/albingroen/quick.nvim)
by [@albingroen](https://github.com/albingroen), substantially diverged:
migrated from `vim.pack` to lazy.nvim, swapped tinted-nvim/tinty for
onedark.nvim, added `typescript-tools.nvim` and `which-key.nvim`, and fixed the
missing `nvim-surround` setup call. Upstream publishes no license file; it is
included here for personal use. All other configuration in
this repository is covered by [LICENSE](LICENSE).
