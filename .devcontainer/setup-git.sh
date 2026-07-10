#!/bin/bash

set -euo pipefail

# Check if the environment variable indicates a GitHub Codespace
if [ "$CODESPACES" = "true" ]; then
    echo "⚡ Environment: GitHub Codespaces detected."
    echo "🔄 Rewriting SSH submodule URLs to HTTPS to utilize Trusted Repositories token..."
    git config --local --replace-all url."https://github.com/".insteadOf "git@github.com:"
else
    echo "💻 Environment: Local Docker Environment detected."
    echo "🔒 Leaving default SSH URL behavior intact to utilize local ssh-agent."
    git config --local --unset-all url."https://github.com/".insteadOf >/dev/null 2>&1 || true
fi
