#!/usr/bin/env bash
# CLI-ONLY EMERGENCY. Not the default. Use only if an AskQuestion tool call
# literally errors AND the manager is in a headless Cursor CLI with a TTY.
# In the normal IDE flow, always call the AskQuestion tool instead.
# Blocking multi-select TUI via fzf. Prints selected option labels, one per line.
# Usage: ask-multi.sh "Prompt text" "Option A" "Option B" ...
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: $0 \"prompt\" \"opt1\" [\"opt2\" ...]" >&2
  exit 2
fi

if ! command -v fzf >/dev/null 2>&1; then
  echo "error: fzf not found — install fzf, or (preferred) call the AskQuestion tool" >&2
  exit 1
fi

PROMPT="$1"
shift

printf '%s\n' "$@" | fzf \
  --multi \
  --prompt="$PROMPT > " \
  --height=40% \
  --reverse \
  --border \
  --info=inline \
  --header="Tab/Shift-Tab multi-select, Enter confirm. Esc cancels."
