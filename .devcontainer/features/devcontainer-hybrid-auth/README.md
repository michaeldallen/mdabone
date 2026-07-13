# Devcontainer Hybrid Auth

This feature installs `devcontainer-hybrid-auth`, a helper that configures GitHub auth URL behavior differently for GitHub Codespaces vs local Docker development.

> Comment: We changed from `--local` to `--global` in 2026-07 because `--local` only affects an existing repository, while `git clone` needs the rewrite before the destination repo exists. Using `--global` makes SSH-to-HTTPS rewriting apply during clone in Codespaces.

## Why `--local` was a problem

Previous command:

```bash
git config --local --replace-all url."https://github.com/".insteadOf "git@github.com:"
```

This did not reliably affect `git clone git@github.com:owner/repo.git`.

Reason:
- `--local` writes config to the current repository's `.git/config`.
- `git clone` runs before the destination repository exists.
- During clone setup, Git does not use the current repo-local config for that rewrite path.
- Result in Codespaces: SSH URL remained SSH, often causing `Permission denied (publickey)`.

## Change made (2026-07)

Updated command:

```bash
git config --global --replace-all url."https://github.com/".insteadOf "git@github.com:"
```

Why this works:
- `--global` applies at user scope.
- The rewrite is available to clone and other Git commands in the Codespaces environment.

## Runtime behavior

In Codespaces (`CODESPACES=true`):
- Set global rewrite to map `git@github.com:` -> `https://github.com/`.

In local Docker (non-Codespaces):
- Remove global rewrite so normal SSH flow can use `ssh-agent`.

```bash
git config --global --unset-all url."https://github.com/".insteadOf >/dev/null 2>&1 || true
```
