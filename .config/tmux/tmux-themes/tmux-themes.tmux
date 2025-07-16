#!/usr/bin/env bash

# CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# "${CURRENT_DIR}/src/themes/tokyonight/moon.sh"

# declare -A COLORS=(
#   [none]="NONE"
#
#   [background]="#222436"
#   [foreground]="#c8d3f5"
#
#   [mode]="#c3e88d"
#   [window]="#545c7e"
#   [window-accent]="#737aa2"
#   [window-active]="#c099ff"
#
#   [bg_dark]="#1e2030"
#   [bg]="#222436"
#   [bg_highlight]="#2f334d"
#   [terminal_black]="#444a73"
#   [fg]="#c8d3f5"
#   [fg_dark]="#828bb8"
#   [fg_gutter]="#3b4261"
#   [dark3]="#545c7e"
#   [comment]="#7a88cf"
#   [dark5]="#737aa2"
#   [blue0]="#3e68d7"
#   [blue]="#82aaff"
#   [cyan]="#86e1fc"
#   [blue1]="#65bcff"
#   [blue2]="#0db9d7"
#   [blue5]="#89ddff"
#   [blue6]="#b4f9f8"
#   [blue7]="#394b70"
#   [purple]="#fca7ea"
#   [magenta2]="#ff007c"
#   [magenta]="#c099ff"
#   [orange]="#ff966c"
#   [yellow]="#ffc777"
#   [green]="#c3e88d"
#   [green1]="#4fd6be"
#   [green2]="#41a6b5"
#   [teal]="#4fd6be"
#   [red]="#ff757f"
#   [red1]="#c53b53"
#   [white]="#ffffff"
# )

# export COLORS
##
# Theme
#
# tmux set -g status-style "fg=#a1aab8 bg=#222436" # 202020
tmux set -g status-style "fg=#a1aab8 bg=default" # 202020

tmux set -g  status-left-length 50

tmux set -g  status-left "" # reset
tmux set -ga status-left "#{?client_prefix,#[fg=#ffc777 bg=#222436],#[fg=#6cbdcc bg=#222436]}█"   # padding
tmux set -ga status-left "#{?client_prefix,#[fg=#222436 bg=#ffc777]P,#[fg=#222436 bg=#6cbdcc]N}"  # icon
tmux set -ga status-left "#{?client_prefix,#[fg=#ffc777 bg=#222436],#[fg=#6cbdcc bg=#222436]}█"   # padding
tmux set -ga status-left "#{?client_prefix,#[fg=#ffc777 bg=#222436],#[fg=#6cbdcc bg=#222436]}║"   # section separator
tmux set -ga status-left "#[fg=#222436 bg=#222436]█"    # padding
tmux set -ga status-left "#[fg=#a1aab8 bg=#222436] #S" # sessions
tmux set -ga status-left "#[fg=#222436 bg=#222436]█"    # padding

tmux set -g status-justify right
tmux set -g window-status-separator "#[fg=#222436]█"

tmux set -g  window-status-format "" # reset
tmux set -ga window-status-format "#[fg=#2d3041]#[bg=#f8f8f2]█" # padding
tmux set -ga window-status-format "#[fg=#f8f8f2]#[bg=#2d3041]#I | #{?pane_in_mode,#{pane_mode}  ,}#W" # number and separator
tmux set -ga window-status-format "#[fg=#2d3041]#[bg=#f8f8f2]█" # padding

tmux set -g  window-status-current-format "" # reset
tmux set -ga window-status-current-format "#[fg=#fa50c0 bg=#44475a]█" # padding
tmux set -ga window-status-current-format "#[fg=#222436 bg=#fa50c0]#I | #{?pane_in_mode,#{pane_mode}  ,}#W" # number and separator
tmux set -ga window-status-current-format "#[fg=#fa50c0 bg=#44475a]█" # padding

# tmux set -g  status-right-style "bg=#2d3041"
tmux set -g  status-right ""

tmux set -g message-command-style "fg=#222436 bg=#c3e88d"
tmux set -g message-style "fg=#222436 bg=#c3e88d"

