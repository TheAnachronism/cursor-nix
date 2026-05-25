#!/usr/bin/env bash
# Update script for cursor and cursor-cli packages
# Usage: ./update.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_NIX="$SCRIPT_DIR/package.nix"
PACKAGE_CLI_NIX="$SCRIPT_DIR/package-cli.nix"

update_gui() {
  echo "=== Checking cursor GUI ==="
  API_RESPONSE=$(curl -sL "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable")
  LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.version')
  DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.debUrl')
  COMMIT_SHA=$(echo "$API_RESPONSE" | jq -r '.commitSha')

  CURRENT_VERSION=$(grep 'version = ' "$PACKAGE_NIX" | head -1 | sed 's/.*"\(.*\)".*/\1/')

  echo "Current version: $CURRENT_VERSION"
  echo "Latest version:  $LATEST_VERSION"

  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "GUI already up to date!"
    return 0
  fi

  echo "Fetching hash for $LATEST_VERSION..."
  NEW_HASH=$(nix-prefetch-url "$DOWNLOAD_URL" 2>&1 | tail -1)
  SRI_HASH=$(nix hash convert --to sri --hash-algo sha256 "$NEW_HASH")

  echo "New SRI hash: $SRI_HASH"

  sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$PACKAGE_NIX"
  sed -i "s|hash = \"sha256-.*\"|hash = \"$SRI_HASH\"|" "$PACKAGE_NIX"

  OLD_SHA=$(grep -oP 'production/\K[a-f0-9]{40}' "$PACKAGE_NIX" | head -1)
  sed -i "s|$OLD_SHA|$COMMIT_SHA|" "$PACKAGE_NIX"

  echo "Updated package.nix to version $LATEST_VERSION"
}

update_cli() {
  echo "=== Checking cursor-cli ==="
  INSTALL_SCRIPT=$(curl -fsSL "https://cursor.com/install")
  LATEST_VERSION=$(echo "$INSTALL_SCRIPT" | grep -oP 'downloads\.cursor\.com/lab/\K[^/]+' | head -1)
  DOWNLOAD_URL="https://downloads.cursor.com/lab/${LATEST_VERSION}/linux/x64/agent-cli-package.tar.gz"

  CURRENT_VERSION=$(grep 'version = ' "$PACKAGE_CLI_NIX" | head -1 | sed 's/.*"\(.*\)".*/\1/')

  echo "Current version: $CURRENT_VERSION"
  echo "Latest version:  $LATEST_VERSION"

  if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "CLI already up to date!"
    return 0
  fi

  echo "Fetching hash for $LATEST_VERSION..."
  NEW_HASH=$(nix-prefetch-url "$DOWNLOAD_URL" 2>&1 | tail -1)
  SRI_HASH=$(nix hash convert --to sri --hash-algo sha256 "$NEW_HASH")

  echo "New SRI hash: $SRI_HASH"

  sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$PACKAGE_CLI_NIX"
  sed -i "s|hash = \"sha256-.*\"|hash = \"$SRI_HASH\"|" "$PACKAGE_CLI_NIX"

  echo "Updated package-cli.nix to version $LATEST_VERSION"
}

update_gui
update_cli
