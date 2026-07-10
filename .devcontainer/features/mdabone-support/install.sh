#!/usr/bin/env bash
set -euo pipefail

# Install required system packages and tools for the MDA devcontainer.
# This feature is intended to replace the remaining postCreateCommand logic.

INSTALL_OPENCAD=${INSTALLOPENCAD:-true}
INSTALL_ANTIGRAVITY=${INSTALLANTIGRAVITY:-true}
PYTHON_PACKAGES=${PYTHONPACKAGES:-numpy trimesh pytest}

if [ "${INSTALL_OPENCAD}" = "true" ]; then
  rm -fv /etc/apt/sources.list.d/yarn.list || true
  apt-get update
  apt-get install -y openscad
fi

if [ "${INSTALL_ANTIGRAVITY}" = "true" ]; then
  if ! command -v curl >/dev/null 2>&1; then
    apt-get update
    apt-get install -y curl
  fi

  if ! command -v agy >/dev/null 2>&1; then
    curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/bin
  fi
fi

if [ -n "${PYTHON_PACKAGES}" ] && command -v python3 >/dev/null 2>&1; then
  python3 -m pip install --upgrade pip
  python3 -m pip install ${PYTHON_PACKAGES}
fi

#EOF