#!/usr/bin/env bash
set -euo pipefail

# Install a command that configures global git auth behavior based on runtime environment.
install -d /usr/local/bin
cat >/usr/local/bin/devcontainer-hybrid-auth <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${CODESPACES:-false}" == "true" ]]; then
  echo "Environment: GitHub Codespaces detected."
  echo "Rewriting SSH GitHub URLs to HTTPS for token-based auth."
  # NOTE (2026-07): This uses --global instead of --local.
  # A --local insteadOf rule only applies inside an existing repository, but
  # `git clone git@github.com:owner/repo.git` runs before the target repo
  # exists and does not read the current repo-local config. That caused clone
  # to keep using SSH (publickey auth) in Codespaces. Global scope ensures the
  # rewrite applies to clone and other Git commands in this user environment.
  git config --global --replace-all url."https://github.com/".insteadOf "git@github.com:"
else
  echo "Environment: Local Docker environment detected."
  echo "Keeping default SSH URL behavior for ssh-agent auth."
  git config --global --unset-all url."https://github.com/".insteadOf >/dev/null 2>&1 || true
fi
EOF
chmod +x /usr/local/bin/devcontainer-hybrid-auth

#EOF
