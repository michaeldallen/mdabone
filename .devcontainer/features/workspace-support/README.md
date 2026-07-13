# Workspace Support Feature

A devcontainer feature that automatically clones repositories listed in `devcontainer.json` customizations into the workspace.

## Purpose

This feature:

- Reads repository definitions from `customizations.codespaces.repositories`
- Clones each repository into `/workspaces/`
- Is idempotent (won't re-clone if already exists)
- Works in both local Dev Containers and GitHub Codespaces

## How It Works

1. The feature runs during devcontainer build/initialization
2. Parses `devcontainer.json` to find `customizations.codespaces.repositories`
3. For each repository, clones it to `/workspaces/<repo-name>` if not already present
4. Provides clear logging of cloning status

## Usage

The feature is configured in `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "./features/workspace-support": {
      "autoClone": true
    }
  },
  "customizations": {
    "codespaces": {
      "repositories": {
        "michaeldallen/mda": { "permissions": { "contents": "write" } },
        "michaeldallen/libmose": { "permissions": { "contents": "write" } },
        "michaeldallen/3d": { "permissions": { "contents": "write" } }
      }
    }
  }
}
```

## Options

- `autoClone` (boolean, default: `true`) — Automatically clone repositories from customizations

## Implementation Notes

- Uses `jq` if available for JSON parsing; falls back to grep/sed
- Cloning is done over HTTPS (compatible with Codespaces authentication)
- Each repository is cloned into a directory named after the repository (e.g., `michaeldallen/mda` → `/workspaces/mda`)
- Feature output uses emoji indicators for clarity (✓ = success, ✗ = failure, 📦 = cloning, etc.)
