#!/usr/bin/env bash

set -euo pipefail

if command -v devcontainer-run-postcreate-hooks >/dev/null 2>&1; then
  exec devcontainer-run-postcreate-hooks
fi

echo "devcontainer-run-postcreate-hooks not found."
echo "Ensure the postcreate-runner feature is enabled in .devcontainer/devcontainer.json."
exit 1