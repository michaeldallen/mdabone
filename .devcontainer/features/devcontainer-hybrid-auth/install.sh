#!/usr/bin/env bash
set -euo pipefail

# Install a command that configures repo-local git auth behavior based on runtime environment.
install -d /usr/local/bin
cat >/usr/local/bin/devcontainer-hybrid-auth <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${CODESPACES:-false}" == "true" ]]; then
  echo "Environment: GitHub Codespaces detected."
  echo "Rewriting SSH GitHub URLs to HTTPS for token-based auth."
  git config --local --replace-all url."https://github.com/".insteadOf "git@github.com:"
else
  echo "Environment: Local Docker environment detected."
  echo "Keeping default SSH URL behavior for ssh-agent auth."
  git config --local --unset-all url."https://github.com/".insteadOf >/dev/null 2>&1 || true
fi
EOF
chmod +x /usr/local/bin/devcontainer-hybrid-auth

#EOF
