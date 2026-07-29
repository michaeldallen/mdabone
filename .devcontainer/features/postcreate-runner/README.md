# Post-create Runner Feature

Installs a reusable command that runs self-registered post-create hooks from all enabled features.

## Purpose

This feature provides a generic post-create execution mechanism so feature-specific post-create logic can live inside each feature and be reused across projects.

## Installed Command

- `devcontainer-run-postcreate-hooks`

## Hook Directory

- `/usr/local/share/devcontainer-postcreate.d`

Each participating feature should copy a hook script into this directory during its `install.sh`.

## Recommended `devcontainer.json` usage

```json
{
  "features": {
    "./features/postcreate-runner": {},
    "./features/devcontainer-hybrid-auth": {},
    "./features/workspace-support": {}
  },
  "postCreateCommand": "devcontainer-run-postcreate-hooks"
}
```
