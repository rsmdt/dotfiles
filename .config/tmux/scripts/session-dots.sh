#!/usr/bin/env bash
# Displays sessions as dots with current session name shown
# Usage: session-dots.sh <current_session_name> <bright_color> <muted_color>

current="$1"
bright="${2:-#a1aab8}"  # default bright color
muted="${3:-#545c7e}"   # default muted color

output=""

# Sort sessions by session index (creation order)
while IFS=$'\t' read -r session; do
    if [[ "$session" == "$current" ]]; then
        output+="#[fg=${bright}]${session} "
    else
        output+="#[fg=${muted}]• "
    fi
done < <(tmux list-sessions -F '#{session_id}	#S' 2>/dev/null | sort -t'$' -k2 -n | cut -f2)

# Trim trailing space
echo "${output% }"
