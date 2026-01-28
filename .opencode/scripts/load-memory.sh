#!/bin/bash
# Load Relevant Memory
# Lists available session memories and lets user choose one to load

MEM_DIR="$HOME/.opencode/memories"

if [[ ! -d "$MEM_DIR" ]]; then
  echo "No memories directory found at $MEM_DIR"
  echo "Create session summaries to build memory."
  exit 1
fi

echo "Available session memories:"
echo ""

# List sessions with numbers
i=1
for file in $(ls -t "$MEM_DIR"/session-*.md 2>/dev/null); do
  if [[ -f "$file" ]]; then
    basename "$file"
    ((i++))
  fi
done | nl

if [[ $i -eq 1 ]]; then
  echo "No session memories found."
  echo "Create session summaries to build memory."
  exit 0
fi

echo ""
read -p "Enter number to view memory (or Ctrl+C to skip): " num

if [[ -n "$num" && "$num" =~ ^[0-9]+$ ]]; then
  file=$(ls -t "$MEM_DIR"/session-*.md 2>/dev/null | sed "${num}q;d")
  if [[ -f "$file" ]]; then
    echo ""
    echo "=== $(basename "$file") ==="
    echo ""
    cat "$file"
  fi
fi
