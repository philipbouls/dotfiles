# Everything these dotfiles assume. Install with: brew bundle
#
# Deliberately scoped to what this repo configures — not a dump of the whole
# machine. Add to it as the configs grow.

tap "tinted-theming/tinted"
tap "charmbracelet/tap"

# Shell & terminal
brew "fish"
brew "tmux"
cask "ghostty"

# Editor + what its plugins shell out to
brew "neovim"      # 0.12+ required: nvim/ uses vim.pack
brew "ripgrep"     # telescope live_grep
brew "fd"          # telescope find_files

# CLI tools the fish config expects
brew "zoxide"      # directory jumping
brew "fzf"         # fuzzy finding
brew "bat"         # `cat` abbreviation
brew "tree"        # `ls` / `l` abbreviations
brew "tinty"       # base16 theming; nvim/init.lua reads its generated colors

# AI coding assistant
brew "crush"       # config in crush/crushrc

# macOS apps configured in macos/
cask "stats"       # menu bar system monitor
cask "rectangle"   # window management
cask "dockdoor"    # dock hover window previews
