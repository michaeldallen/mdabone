#!/usr/bin/env bash

set -euo pipefail

hooks_dir="/usr/local/share/devcontainer-postcreate.d"
source_hook="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/postCreateCommand.sh"
target_hook="${hooks_dir}/20-devcontainer-hybrid-auth.sh"

mkdir -p "${hooks_dir}"
install -m 755 "${source_hook}" "${target_hook}"

echo "Devcontainer Hybrid Auth hook registered: ${target_hook}"
