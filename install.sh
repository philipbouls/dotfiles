#!/usr/bin/env bash
# Symlink the configs in this repo into their expected locations.
# Anything already present is moved to <path>.backup first.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

link() {
	local src="$DOTFILES/$1" dest="$2"

	if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
		printf '  ok    %s\n' "$dest"
		return
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		mv "$dest" "$dest.backup"
		printf '  moved %s -> %s.backup\n' "$dest" "$dest"
	fi

	mkdir -p "$(dirname "$dest")"
	ln -s "$src" "$dest"
	printf '  link  %s -> %s\n' "$dest" "$src"
}

printf 'Installing dotfiles from %s\n' "$DOTFILES"

link fish            "$CONFIG/fish"
link nvim            "$CONFIG/nvim"
link ghostty         "$CONFIG/ghostty"
link .tmux.conf      "$HOME/.tmux.conf"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	printf '\nInstalling tpm...\n'
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [ "$(uname)" = "Darwin" ]; then
	printf '\n'
	"$DOTFILES/macos/defaults.sh"
fi

cat <<'DONE'

Done. Next steps:
  - Start tmux and press C-a I to install tmux plugins
  - Start nvim; vim.pack fetches plugins on first launch
  - Run :Mason in nvim to install LSP servers, formatters and linters
  - macOS: run ./macos/apps.sh to import Stats/Rectangle/DockDoor settings
    (it quits those apps briefly, so it is not run automatically)
DONE
