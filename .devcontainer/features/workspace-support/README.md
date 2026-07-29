# Workspace Support Feature

A devcontainer feature that automatically clones repositories listed in `devcontainer.json` customizations into the workspace.

## Purpose

This feature:

- Reads repository definitions from `customizations.codespaces.repositories`
- Clones each repository into `/workspaces/`
- Updates `multi-repo.code-workspace` so it always matches configured repositories
- Is idempotent (won't re-clone if already exists)
- Works in both local Dev Containers and GitHub Codespaces

## How It Works

1. During feature install, this feature self-registers a post-create hook in `/usr/local/share/devcontainer-postcreate.d/`.
2. At container post-create time, the reusable `devcontainer-run-postcreate-hooks` command executes registered hooks.
3. This hook parses `devcontainer.json` to find `customizations.codespaces.repositories`.
4. It rewrites `multi-repo.code-workspace` to include the primary repo plus each configured repository.
5. For each repository, it clones to `/workspaces/<repo-name>` if not already present.
6. It provides clear logging of sync and cloning status.

## Usage

The feature is configured in `.devcontainer/devcontainer.json`:

```json
{
  "features": {
    "./features/postcreate-runner": {},
    "./features/workspace-support": {
      "autoClone": true
    }
  },
  "postCreateCommand": "devcontainer-run-postcreate-hooks",
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

- Registers `30-workspace-support.sh` into `/usr/local/share/devcontainer-postcreate.d/`
- Uses `jq` for JSON parsing and fails fast if parsing fails
- Keeps `multi-repo.code-workspace` synchronized with `customizations.codespaces.repositories`
- In Codespaces, cloning is done over HTTPS to use `GITHUB_TOKEN` auth
- Outside Codespaces, cloning uses SSH (`git@github.com:`) for local `ssh-agent` workflows
- In Codespaces, each configured repo is preflight-checked via GitHub API to surface missing token grants clearly
- Outside Codespaces, a startup SSH preflight warning is shown if `git@github.com` auth does not appear ready
- Each repository is cloned into a directory named after the repository (e.g., `michaeldallen/mda` -> `/workspaces/mda`)
- Feature output uses emoji indicators for clarity (✓ = success, ✗ = failure, 📦 = cloning, etc.)
