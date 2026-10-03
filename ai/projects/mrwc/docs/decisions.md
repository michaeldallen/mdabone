# Decisions

## 001: Project location and independence
Lives in `ai/projects/mrwc/`, self-contained, following the hub's `ai/projects/` convention. Supersedes `codespaces-workspaces`, which is ignored.

## 002: Repo list in `repos.mk`
The Makefile reads its repo list from `repos.mk`, not from `multi-repo.code-workspace` (which uses absolute paths). A consistency check against the workspace file may come later.

## 003: Status output
Use `git status --short --branch` for each managed repo. This reports the current branch, upstream divergence when an upstream is configured, and working-tree changes. Missing paths and non-Git directories are reported as errors, and the target exits unsuccessfully if any repo cannot be checked.
