#!/bin/bash
# Context Reset Helper
# Prompts for compaction type and shows relevant template

echo "Choose compaction type:"
echo "1) After Exploration"
echo "2) After Milestone"
echo "3) Context Switch"
echo "4) Full Reset"
echo ""
read -p "Select [1-4]: " choice

TEMPLATE_DIR="$HOME/.config/opencode/context-templates"

case $choice in
  1)
    cat "$TEMPLATE_DIR/compact-exploration.txt"
    ;;
  2)
    cat "$TEMPLATE_DIR/compact-milestone.txt"
    ;;
  3)
    cat "$TEMPLATE_DIR/compact-switch.txt"
    ;;
  4)
    echo "[COMPACT: FULL RESET - Starting fresh session]"
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac
