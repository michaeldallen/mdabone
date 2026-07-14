#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
devcontainer_json="${script_dir}/devcontainer.json"
features_root="${script_dir}/features"

# Extract feature directories from devcontainer.json using regex
feature_dirs=()
while IFS= read -r line; do
  # Match lines like: "./features/feature-name": {
  if [[ $line =~ \"(\.\/features\/([^\"]+))\" ]]; then
    feature_dir="${BASH_REMATCH[2]}"
    echo "[DEBUG] Adding feature_dir: $feature_dir"
    feature_dirs+=("$feature_dir")
  fi
done < "$devcontainer_json"

# Run postCreateCommand.sh for each feature
for feature_dir in "${feature_dirs[@]}"; do
  feature_script="${features_root}/${feature_dir}/postCreateCommand.sh"
  if [[ -f "${feature_script}" ]]; then
    echo "[DEBUG] Running postCreateCommand.sh: $feature_script"
    bash "${feature_script}"
  fi
done