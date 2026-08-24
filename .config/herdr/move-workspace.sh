#!/bin/sh
set -eu

delta=$1

socket_request() {
  printf '%s\n' "$1" | nc -U -w 1 "$HERDR_SOCKET_PATH" | head -1
}

workspaces=$(socket_request '{"id":"list","method":"workspace.list","params":{}}')
current_index=$(printf '%s' "$workspaces" | jq '.result.workspaces | map(.focused) | index(true)')
last_index=$(printf '%s' "$workspaces" | jq '.result.workspaces | length - 1')
workspace_id=$(printf '%s' "$workspaces" | jq -r --argjson i "$current_index" '.result.workspaces[$i].workspace_id')

target_index=$((current_index + delta))
if [ "$target_index" -lt 0 ]; then
  target_index=0
fi
if [ "$target_index" -gt "$last_index" ]; then
  target_index=$last_index
fi

move_request=$(printf '{"id":"move","method":"workspace.move","params":{"workspace_id":"%s","insert_index":%d}}' "$workspace_id" "$target_index")
socket_request "$move_request" >/dev/null
