#!/usr/bin/env bash
# macOS system defaults.
# Safe to re-run. Some changes need a logout or app restart to take effect.

set -euo pipefail

[ "$(uname)" = "Darwin" ] || { echo "macos/defaults.sh: not macOS, skipping"; exit 0; }

echo "Applying macOS defaults..."

# --- Keyboard -------------------------------------------------------------
# Hold a key and it repeats fast, instead of popping up the accent menu.

# Disable the press-and-hold accent picker so holding a key repeats it.
defaults write -g ApplePressAndHoldEnabled -bool false

# Repeat rate once repeating starts. Lower is faster; 2 is one notch above
# the fastest the Settings UI exposes (1 is fastest, 120 is slowest).
defaults write -g KeyRepeat -int 2

# How long to hold before repeating begins. Lower is shorter; 15 = 225ms.
defaults write -g InitialKeyRepeat -int 15

echo "  keyboard: press-and-hold off, KeyRepeat=2, InitialKeyRepeat=15"

cat <<'DONE'

Done. Note:
  - Already-running apps keep the old key repeat until you restart them.
  - Log out and back in to apply everywhere.
DONE
