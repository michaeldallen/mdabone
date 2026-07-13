#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
devcontainer_json="${script_dir}/devcontainer.json"
features_root="${script_dir}/features"

mapfile -t feature_dirs < <(
  python3 - "${devcontainer_json}" <<'PY'
import json
import os
import sys

devcontainer_json = sys.argv[1]

with open(devcontainer_json, encoding="utf-8") as handle:
    data = json.load(handle)

features = data.get("features", {})
for feature_name in features:
    if feature_name.startswith("./features/"):
        print(feature_name.removeprefix("./features/"))
PY
)

for feature_dir in "${feature_dirs[@]}"; do
  feature_script="${features_root}/${feature_dir}/postCreateCommand.sh"
  if [[ -f "${feature_script}" ]]; then
    bash "${feature_script}"
  fi
done