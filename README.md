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
  - Plugins managed by **`vim.pack`**, Neovim's built-in plugin manager — pinned in `nvim/nvim-pack-lock.json`
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
    accent picker (`ApplePressAndHoldEnabled` off, `KeyRepeat` 2,
    `InitialKeyRepeat` 15)

- **App preferences** — `macos/apps.sh` imports the committed plists
  - [Stats](https://github.com/exelban/stats) — menu bar system monitor
    (CPU, GPU, RAM, disk, network, battery, clock)
  - [Rectangle](https://rectangleapp.com) — window management
  - [DockDoor](https://github.com/ejbills/DockDoor) — dock hover window previews

## Structure

```
dotfiles/
├── fish/
│   └── config.fish           # Fish shell config and abbreviations
├── nvim/
│   ├── init.lua              # Plugin list and per-plugin setup
│   ├── lua/
│   │   └── basics.lua        # Core options and keymaps
│   ├── nvim-pack-lock.json   # Pinned plugin revisions
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

Note **Neovim 0.12+** is required — `nvim/` uses `vim.pack`, which does not
exist in earlier versions.

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

Start tmux and press `C-a I` to install plugins. Start Neovim and `vim.pack`
will fetch plugins on first launch; run `:Mason` to install language servers,
formatters, and linters.

## Notes

- **Theming is optional.** `nvim/init.lua` picks up a base16 colorscheme from
  [tinty](https://github.com/tinted-theming/tinty) if
  `~/.local/share/tinted-theming/tinty/base16-vim-colors-file.vim` exists, and
  falls back to the default colorscheme if it does not. `tinty` is in the
  Brewfile; to generate that file, pick a scheme once:

  ```sh
  tinty install
  tinty apply base16-default-dark   # `tinty list` shows all schemes
  ```

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
by [@albingroen](https://github.com/albingroen), with local fixes: added
`typescript-tools.nvim` (referenced by a keymap and the lockfile but absent
from the plugin list) and the missing `nvim-surround` setup call. Upstream
publishes no license file; it is included here for personal use. All other configuration in
this repository is covered by [LICENSE](LICENSE).
