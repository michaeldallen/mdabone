#!/usr/bin/env bash
# Workspace Support Feature install hook.
# Registers a reusable post-create hook script.

set -euo pipefail

hooks_dir="/usr/local/share/devcontainer-postcreate.d"
source_hook="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/postCreateCommand.sh"
target_hook="${hooks_dir}/30-workspace-support.sh"

mkdir -p "${hooks_dir}"
install -m 755 "${source_hook}" "${target_hook}"

echo "Workspace Support hook registered: ${target_hook}"
