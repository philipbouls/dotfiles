#!/usr/bin/env bash
# Import saved preferences for Stats, Rectangle and DockDoor.
#
# Each app is quit first: macOS caches preferences in cfprefsd, and a running
# app will write its in-memory state back over the imported file on exit.
#
# `defaults import` REPLACES the whole preference domain, so anything not in
# the committed plist (window positions, update-checker state) resets. Whatever
# is there now is exported to BACKUP_DIR first.

set -euo pipefail

[ "$(uname)" = "Darwin" ] || { echo "macos/apps.sh: not macOS, skipping"; exit 0; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${PREFS_BACKUP_DIR:-$HOME/.dotfiles-prefs-backup/$(date +%Y%m%d-%H%M%S)}"

import() {
	local app="$1" domain="$2" file="$HERE/$1.plist"

	if [ ! -f "$file" ]; then
		printf '  skip  %s (no %s.plist)\n' "$app" "$app"
		return
	fi

	# Back up whatever this machine has now, before it is replaced.
	if defaults read "$domain" >/dev/null 2>&1; then
		mkdir -p "$BACKUP_DIR"
		defaults export "$domain" "$BACKUP_DIR/$domain.plist"
		printf '  backup %-9s -> %s\n' "$app" "$BACKUP_DIR/$domain.plist"
	fi

	local was_running=0
	if pgrep -xq "$app"; then
		was_running=1
		osascript -e "tell application \"$app\" to quit" 2>/dev/null || killall "$app" 2>/dev/null || true
		# Give it a moment to flush and exit.
		for _ in 1 2 3 4 5 6 7 8 9 10; do
			pgrep -xq "$app" || break
			sleep 0.3
		done
	fi

	defaults import "$domain" "$file"
	printf '  import %-10s -> %s\n' "$app" "$domain"

	[ "$was_running" -eq 1 ] && open -ga "$app" 2>/dev/null || true
}

echo "Importing app preferences..."

import Stats     eu.exelban.Stats
import Rectangle com.knollsoft.Rectangle
import DockDoor  com.ethanbills.DockDoor

# Drop the preferences cache so nothing stale gets written back.
killall cfprefsd 2>/dev/null || true

printf '\n'
if [ -d "$BACKUP_DIR" ]; then
	printf 'Previous preferences backed up to:\n  %s\n' "$BACKUP_DIR"
	printf 'Restore one with: defaults import <domain> %s/<domain>.plist\n\n' "$BACKUP_DIR"
fi

cat <<'DONE'
Note:
  - DockDoor needs Screen Recording and Accessibility permission; Rectangle
    needs Accessibility. Grant those in System Settings > Privacy & Security.
  - Menu bar item positions are per-display and may need a Cmd-drag to taste.
DONE
