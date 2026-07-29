#!/usr/bin/env bash

set -euo pipefail

if [[ "${CODESPACES:-false}" == "true" ]]; then
  echo "Environment: GitHub Codespaces detected."
  echo "Rewriting SSH GitHub URLs to HTTPS for token-based auth."
  # A local config does not cover fresh clone targets; global does.
  git config --global --replace-all url."https://github.com/".insteadOf "git@github.com:"
else
  echo "Environment: Local Docker environment detected."
  echo "Keeping default SSH URL behavior for ssh-agent auth."
  git config --global --unset-all url."https://github.com/".insteadOf >/dev/null 2>&1 || true
fi

echo "Devcontainer Hybrid Auth post-create complete."
