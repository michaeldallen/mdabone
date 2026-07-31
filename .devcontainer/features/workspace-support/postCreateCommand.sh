#!/usr/bin/env bash
# Workspace Support post-create hook.
# Reads customizations.codespaces.repositories and clones listed repositories into /workspaces/

set -euo pipefail

FEATURE_AUTO_CLONE="${DEVCONTAINER_FEATURE_WORKSPACE_SUPPORT_AUTOCLONE:-true}"

# Ensure github.com is trusted for SSH clones to avoid interactive fingerprint prompts.
ensure_github_known_host() {
    local ssh_dir="${HOME}/.ssh"
    local known_hosts_file="${ssh_dir}/known_hosts"

    mkdir -p "${ssh_dir}"
    chmod 700 "${ssh_dir}" || true
    touch "${known_hosts_file}"
    chmod 600 "${known_hosts_file}" || true

    if ssh-keygen -F github.com -f "${known_hosts_file}" >/dev/null 2>&1; then
        return 0
    fi

    echo "🔐 Adding github.com SSH host keys to known_hosts..."
    if ssh-keyscan -H github.com >> "${known_hosts_file}" 2>/dev/null; then
        echo "✓ Added github.com host keys"
    else
        echo "⚠ Could not pre-load github.com host keys. Clone may prompt for fingerprint."
    fi
}

# Warn (without failing) when local SSH auth to GitHub is not ready.
check_local_ssh_auth() {
    if [[ "${CODESPACES:-false}" == "true" ]]; then
        return 0
    fi

    if ! command -v ssh >/dev/null 2>&1; then
        echo "⚠ SSH client not found. Local SSH clone may fail."
        return 0
    fi

    local ssh_output
    ssh_output=$(ssh -T -o BatchMode=yes -o ConnectTimeout=5 git@github.com 2>&1 || true)

    if [[ "${ssh_output}" == *"successfully authenticated"* ]]; then
        echo "✓ Local SSH auth to GitHub looks good"
        return 0
    fi

    echo "⚠ Local SSH auth to GitHub does not appear ready."
    echo "  Expected for first-time setup, but SSH clones may fail."
    echo "  Check: ssh-add -l"
    echo "  Test:  ssh -T git@github.com"
}

# Find devcontainer.json in common locations
find_devcontainer_json() {
    local repo_root
    local devcontainer_file

    # Get the repository root
    if ! repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        return 1
    fi

    devcontainer_file="${repo_root}/.devcontainer/devcontainer.json"
    
    if [[ -f "${devcontainer_file}" ]]; then
        echo "${devcontainer_file}"
        return 0
    fi

    return 1
}

# Parse repositories using jq only (fail fast on any parse or schema error)
extract_repositories() {
    local devcontainer_json="$1"

    if ! command -v jq >/dev/null 2>&1; then
        echo "✗ Error: jq is required to parse ${devcontainer_json}, but it is not installed." >&2
        return 1
    fi

    # Fail immediately if JSON is invalid or required path is missing.
    jq -e -r '.customizations.codespaces.repositories | keys[]' "$devcontainer_json"
}

# Keep the workspace file in sync with configured repository list.
sync_workspace_file() {
        local repo_root="$1"
        local repositories="$2"
        local workspace_file="${repo_root}/multi-repo.code-workspace"
        local temp_file
        local root_repo_name

        temp_file=$(mktemp)
        root_repo_name="$(basename "${repo_root}")"

        {
                cat <<'EOF'
{
    "folders": [
        {
            "name": "mdabone (MRWC Hub)",
            "path": "."
        }
EOF

                while IFS= read -r repo_full_name; do
                        local repo_name
                        [[ -z "${repo_full_name}" ]] && continue
                        repo_name="${repo_full_name##*/}"

                        # Avoid duplicate folder entries if the primary repo is listed.
                        [[ "${repo_name}" == "${root_repo_name}" ]] && continue

                        cat <<EOF
        ,{
            "name": "${repo_name}",
            "path": "../${repo_name}"
        }
EOF
                done <<< "${repositories}"

                cat <<'EOF'
    ],
    "settings": {
        "git.autorefresh": true
    }
}
EOF
        } > "${temp_file}"

        # Normalize formatting for stable diffs and readability.
        jq . "${temp_file}" > "${temp_file}.formatted"
        mv "${temp_file}.formatted" "${temp_file}"

        if [[ -f "${workspace_file}" ]] && cmp -s "${temp_file}" "${workspace_file}"; then
                rm -f "${temp_file}"
                echo "✓ Workspace file already up to date: ${workspace_file}"
                return 0
        fi

        mv "${temp_file}" "${workspace_file}"
        echo "✓ Updated workspace file: ${workspace_file}"
}

# Clone a single repository
clone_repository() {
    local repo_full_name="$1"  # e.g., "michaeldallen/mda"
    local repo_name="${repo_full_name##*/}"  # Extract just the repo name after /
    local clone_path="/workspaces/${repo_name}"
    local clone_url

    # Codespaces authentication is token-based; prefer HTTPS there.
    if [[ "${CODESPACES:-false}" == "true" ]]; then
        clone_url="https://github.com/${repo_full_name}.git"
    else
        clone_url="git@github.com:${repo_full_name}.git"
    fi

    if [[ -d "${clone_path}" ]]; then
        echo "✓ Repository ${repo_name} already exists at ${clone_path}"
        return 0
    fi

    echo "📦 Cloning ${repo_full_name} into ${clone_path}..."

    # Fail early with a clear message when the Codespaces token lacks access
    # to a configured repository.
    if [[ "${CODESPACES:-false}" == "true" ]] && [[ -n "${GITHUB_TOKEN:-}" ]]; then
        local api_status
        api_status=$(curl -sS -o /dev/null -w "%{http_code}" \
            -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            -H "Accept: application/vnd.github+json" \
            "https://api.github.com/repos/${repo_full_name}" || true)

        if [[ "${api_status}" != "200" ]]; then
            echo "✗ Codespaces token cannot access ${repo_full_name} (HTTP ${api_status})."
            echo "  Ensure customizations.codespaces.repositories includes ${repo_full_name},"
            echo "  then recreate the codespace so GitHub can request/grant access."
            return 1
        fi
    fi

    if git clone "${clone_url}" "${clone_path}"; then
        echo "✓ Successfully cloned ${repo_full_name}"
        return 0
    else
        echo "✗ Failed to clone ${repo_full_name}"
        return 1
    fi
}

main() {
    echo "=== Workspace Support Feature ==="

    # Find devcontainer.json
    local devcontainer_json
    if ! devcontainer_json=$(find_devcontainer_json); then
        echo "⚠ devcontainer.json not found. Skipping workspace setup."
        return 0
    fi

    echo "📍 Using devcontainer config: ${devcontainer_json}"

    # Preload github.com host keys only when SSH cloning may be used.
    if [[ "${CODESPACES:-false}" != "true" ]]; then
        ensure_github_known_host
        check_local_ssh_auth
    fi

    # Extract repositories
    local repositories
    if ! repositories=$(extract_repositories "${devcontainer_json}"); then
        echo "✗ Error: Failed to parse repositories from ${devcontainer_json}." >&2
        return 1
    fi

    if [[ -z "${repositories}" ]]; then
        echo "ℹ No repositories found in customizations.codespaces.repositories"
        sync_workspace_file "$(dirname "$(dirname "${devcontainer_json}")")" ""
        return 0
    fi

    # Sync the workspace file before any cloning attempt.
    sync_workspace_file "$(dirname "$(dirname "${devcontainer_json}")")" "${repositories}"

    if [[ "${FEATURE_AUTO_CLONE}" != "true" ]]; then
        echo "Auto-clone disabled. Skipping repository cloning."
        return 0
    fi

    local clone_count=0
    local fail_count=0

    echo "🔄 Processing repositories..."
    while IFS= read -r repo; do
        if [[ -n "${repo}" ]]; then
            if clone_repository "${repo}"; then
                clone_count=$((clone_count + 1))
            else
                fail_count=$((fail_count + 1))
            fi
        fi
    done <<< "${repositories}"

    echo ""
    echo "=== Workspace Setup Complete ==="
    echo "✓ Cloned: ${clone_count}"
    if [[ ${fail_count} -gt 0 ]]; then
        echo "✗ Failed: ${fail_count}"
        return 1
    fi

    return 0
}

main "$@"