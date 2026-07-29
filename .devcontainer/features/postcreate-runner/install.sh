#!/usr/bin/env bash
set -euo pipefail

HOOKS_DIR="/usr/local/share/devcontainer-postcreate.d"
RUNNER_PATH="/usr/local/bin/devcontainer-run-postcreate-hooks"

mkdir -p "${HOOKS_DIR}"

cat > "${RUNNER_PATH}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

hooks_dir="${DEVCONTAINER_POSTCREATE_HOOKS_DIR:-/usr/local/share/devcontainer-postcreate.d}"

if [[ ! -d "${hooks_dir}" ]]; then
  echo "No post-create hooks directory found at ${hooks_dir}. Nothing to run."
  exit 0
fi

mapfile -t hooks < <(find "${hooks_dir}" -maxdepth 1 -type f -name '*.sh' | sort)

if [[ ${#hooks[@]} -eq 0 ]]; then
  echo "No registered post-create hooks found in ${hooks_dir}."
  exit 0
fi

echo "=== Running registered post-create hooks ==="

failed=0
for hook in "${hooks[@]}"; do
  echo "-> ${hook}"
  if bash "${hook}"; then
    echo "OK: ${hook}"
  else
    echo "FAIL: ${hook}"
    failed=$((failed + 1))
  fi
  echo
 done

if [[ ${failed} -gt 0 ]]; then
  echo "Post-create hooks completed with ${failed} failure(s)."
  exit 1
fi

echo "All post-create hooks completed successfully."
EOF

chmod 755 "${RUNNER_PATH}"

echo "Post-create runner installed: ${RUNNER_PATH}"
