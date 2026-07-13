#!/usr/bin/env bash
# Workspace Support Feature for devcontainers
# Reads customizations.codespaces.repositories and clones listed repositories into /workspaces/

set -e

FEATURE_AUTO_CLONE="${DEVCONTAINER_FEATURE_WORKSPACE_SUPPORT_AUTOCLONE:-true}"

# Find devcontainer.json in common locations
find_devcontainer_json() {
    local devcontainer_file
    
    # Try .devcontainer/devcontainer.json first (most common)
    if [[ -f "/workspaces/mdabone/.devcontainer/devcontainer.json" ]]; then
        echo "/workspaces/mdabone/.devcontainer/devcontainer.json"
        return 0
    fi
    
    # Search in /workspaces root for devcontainer.json
    for dir in /workspaces/*/; do
        if [[ -f "${dir}.devcontainer/devcontainer.json" ]]; then
            echo "${dir}.devcontainer/devcontainer.json"
            return 0
        fi
    done
    
    # Fallback to current directory structure
    if [[ -f ".devcontainer/devcontainer.json" ]]; then
        echo ".devcontainer/devcontainer.json"
        return 0
    fi
    
    return 1
}

# Parse repositories using jq if available, otherwise grep/sed
extract_repositories() {
    local devcontainer_json="$1"
    
    # Check if jq is available
    if command -v jq &> /dev/null; then
        # Use jq to extract owner/repo pairs
        jq -r '.customizations.codespaces.repositories | keys[]' "$devcontainer_json" 2>/dev/null || true
    else
        # Fallback: use grep and sed to extract repository names
        # Look for patterns like "michaeldallen/repo-name":
        grep -o '"[^/]*\/[^"]*"' "$devcontainer_json" 2>/dev/null | sed 's/"//g' || true
    fi
}

# Clone a single repository
clone_repository() {
    local repo_full_name="$1"  # e.g., "michaeldallen/mda"
    local repo_name="${repo_full_name##*/}"  # Extract just the repo name after /
    local clone_path="/workspaces/${repo_name}"
    local clone_url="git@github.com:${repo_full_name}.git"
    
    if [[ -d "${clone_path}" ]]; then
        echo "✓ Repository ${repo_name} already exists at ${clone_path}"
        return 0
    fi
    
    echo "📦 Cloning ${repo_full_name} into ${clone_path}..."
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
    
    if [[ "${FEATURE_AUTO_CLONE}" != "true" ]]; then
        echo "Auto-clone disabled. Skipping repository cloning."
        return 0
    fi
    
    # Find devcontainer.json
    local devcontainer_json
    if ! devcontainer_json=$(find_devcontainer_json); then
        echo "⚠ devcontainer.json not found. Skipping workspace setup."
        return 0
    fi
    
    echo "📍 Using devcontainer config: ${devcontainer_json}"
    
    # Extract repositories
    local repositories
    repositories=$(extract_repositories "${devcontainer_json}")
    
    if [[ -z "${repositories}" ]]; then
        echo "ℹ No repositories found in customizations.codespaces.repositories"
        return 0
    fi
    
    local clone_count=0
    local fail_count=0
    
    echo "🔄 Processing repositories..."
    while IFS= read -r repo; do
        if [[ -n "${repo}" ]]; then
            if clone_repository "${repo}"; then
                ((clone_count++))
            else
                ((fail_count++))
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
