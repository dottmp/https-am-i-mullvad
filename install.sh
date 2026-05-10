#!/bin/bash
# install.sh — Install https-am-i-mullvad to ~/.local/bin

set -e

TARGET_DIR="${HOME}/.local/bin"
TARGET="${TARGET_DIR}/https-am-i-mullvad"

mkdir -p "$TARGET_DIR"
cp "./https-am-i-mullvad.sh" "$TARGET"
chmod +x "$TARGET"

echo "Installed: ${TARGET}"
