#!/usr/bin/env bash
# dictinstant — APT repository setup for Debian / Ubuntu.
# Usage: curl -fsSL https://raw.githubusercontent.com/DariushKhosrowan/dictinstant/main/scripts/apt-setup.sh | sudo bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root (try: sudo bash)." >&2
  exit 1
fi

REPO_BASE="https://DariushKhosrowan.github.io/dictinstant/repo"
KEY_URL="${REPO_BASE}/dictinstant.gpg"
LIST_URL="${REPO_BASE}/dictinstant.list"

CERT="/usr/share/keyrings/dictinstant-archive-keyring.gpg"
LIST="/etc/apt/sources.list.d/dictinstant.list"

echo "◆ Adding dictinstant GPG key…"
curl -fsSL "$KEY_URL" -o "$CERT"
chmod 644 "$CERT"

echo "◆ Adding dictinstant APT source list…"
curl -fsSL "$LIST_URL" -o "$LIST"
chmod 644 "$LIST"

echo "◆ Updating package lists…"
apt-get update

echo ""
echo "✔ dictinstant repository ready. Now install with:"
echo "   sudo apt install -y dictinstant"
echo "   dictinstant"
