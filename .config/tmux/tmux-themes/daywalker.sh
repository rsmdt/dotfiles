#!/usr/bin/env bash
# Daywalker Theme for tmux
# A minimal theme with session dots and window list
#
# Usage: daywalker.sh <dark|light>

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-dark}"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Load Color Palette
# └─────────────────────────────────────────────────────────────────────────────
if [[ "$MODE" == "light" ]]; then
    source "${SCRIPT_DIR}/colors/light.sh"
else
    source "${SCRIPT_DIR}/colors/dark.sh"
fi

# Default contrast color (dark themes use bg, light themes override)
contrast="${contrast:-$bg}"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Status Bar
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g status-style "fg=${fg},bg=${bg}"
tmux set -g status-left-length 100
tmux set -g status-right-length 100
tmux set -g status-justify right

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Status Left: [N/P] • Session Dots
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g status-left ""
# Mode indicator [N] or [P]
tmux set -ga status-left "#{?client_prefix,#[fg=${bg} bg=${warning} bold] P #[fg=${warning} bg=${bg}],#[fg=${bg} bg=${primary} bold] N #[fg=${primary} bg=${bg}]}"
# Session dots (current session name in bright, others as • in muted)
tmux set -ga status-left "#[fg=${fg_muted} bg=${bg} nobold] 󰆧 #(~/.config/tmux/scripts/session-dots.sh '#S' '${fg}' '${fg_muted}') "

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Status Right: Empty (windows are right-justified)
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g status-right ""

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Window List
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g window-status-separator " "

# Inactive windows
tmux set -g window-status-style "fg=${fg_muted},bg=${bg}"
tmux set -g window-status-format " #I | #{?pane_in_mode,#{pane_mode}  ,}#W "

# Active window (highlighted with background)
tmux set -g window-status-current-style "fg=${contrast},bg=${accent},bold"
tmux set -g window-status-current-format " #I | #{?pane_in_mode,#{pane_mode}  ,}#W "

# Bell and activity
tmux set -g window-status-bell-style "fg=${bg},bg=${warning},bold"
tmux set -g window-status-activity-style "fg=${bg},bg=${primary}"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Messages & Mode
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g message-style "fg=${contrast},bg=${success}"
tmux set -g message-command-style "fg=${contrast},bg=${success}"
tmux set -g mode-style "fg=${contrast},bg=${primary}"

# ┌─────────────────────────────────────────────────────────────────────────────
# │ Pane Borders
# └─────────────────────────────────────────────────────────────────────────────
tmux set -g pane-border-style "fg=${border}"
tmux set -g pane-active-border-style "fg=${accent}"
