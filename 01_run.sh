#!/usr/bin/env bash
set -euo pipefail

# 01_run.sh — run Godot project and auto-restart on file changes
# Usage:
#   ./01_run.sh [project_path]
# Environment:
#   GODOT_BIN - path to godot binary (defaults to `godot` or `godot4` on PATH)
#   WATCH - if set to 0, disables file-watching restart (default: 1)

GODOT_BIN=${GODOT_BIN:-$(command -v godot || command -v godot4 || true)}
# Fallbacks if not on PATH: check ~/bin and common download name
if [ -z "$GODOT_BIN" ]; then
  if [ -x "$HOME/bin/godot" ]; then
    GODOT_BIN="$HOME/bin/godot"
  elif [ -x "$HOME/Downloads/Godot_v4.6.3-stable_linux.x86_64" ]; then
    GODOT_BIN="$HOME/Downloads/Godot_v4.6.3-stable_linux.x86_64"
  fi
fi

if [ -z "$GODOT_BIN" ]; then
  echo "Error: Godot binary not found. Set GODOT_BIN or install godot (godot or godot4 must be on PATH)."
  exit 1
fi

if [ "$#" -ge 1 ]; then
  PROJECT_DIR=$1
else
  # Auto-detect project path: prefer current dir if it contains project.godot,
  # then Croptails folder, then search for first project.godot under cwd
  if [ -f "project.godot" ]; then
    PROJECT_DIR=.
  elif [ -d "Croptails" ]; then
    PROJECT_DIR=Croptails
  else
    found=$(find . -maxdepth 4 -type f -name "project.godot" | head -n1 || true)
    if [ -n "$found" ]; then
      PROJECT_DIR=$(dirname "$found")
    else
      echo "Error: cannot detect project. Provide project path as first argument."
      exit 1
    fi
  fi
fi

if [ ! -d "$PROJECT_DIR" ]; then
  echo "Error: project directory '$PROJECT_DIR' not found or is not a directory."
  exit 1
fi

WATCH=${WATCH:-1}

child_pid=0
trap 'echo "Stopping..."; [ "$child_pid" -ne 0 ] && kill "$child_pid" 2>/dev/null || true; exit 0' INT TERM

restart_child() {
  if [ "$child_pid" -ne 0 ]; then
    kill "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
  fi
}

echo "Using Godot binary: $GODOT_BIN"
echo "Project: $PROJECT_DIR"

while true; do
  echo "Starting Godot..."
  "$GODOT_BIN" --path "$PROJECT_DIR" &
  child_pid=$!

  if [ "$WATCH" -ne 0 ] && command -v inotifywait >/dev/null 2>&1; then
    # watch for changes inside project and restart Godot on first event
    echo "Watching '$PROJECT_DIR' for changes (inotifywait)... Press Ctrl+C to stop."
    inotifywait -e modify,create,delete,move -r "$PROJECT_DIR" >/dev/null 2>&1 || true
    echo "File change detected — restarting Godot"
    restart_child
    sleep 0.5
    continue
  else
    # No watcher available — just wait for Godot to exit and then restart
    wait "$child_pid" || true
    echo "Godot exited — restarting in 1s..."
    sleep 1
  fi
done
