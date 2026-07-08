# ADR-001: Dynamic Hybrid Git Authentication for Submodules

## Status
Accepted

## Context
Our repository relies on private Git submodules. Development occurs across a hybrid workspace:
1. **Local Workstations:** A Linux machine using `ssh-agent` forwarding to authenticate to GitHub via SSH (`git@github.com:`).
2. **Cloud/Travel Environments:** A browser-based GitHub Codespaces instance. This environment has no access to a local SSH agent and must rely on GitHub's browser-managed HTTPS OAuth tokens.

We require a single, unified `.devcontainer` configuration that works seamlessly in both environments without modifying committed repository files (like `.gitmodules`) or forcing the developer to maintain environment-specific branches.

## Decision
We will maintain **SSH (`git@github.com:`)** as the canonical URL format in the committed `.gitmodules` file. 

To bridge the authentication gap in browser-based Codespaces, we will inject a dynamic, environment-aware shell script (`setup-git.sh`) into the Dev Container's `postCreateCommand` lifecycle hook.

This script will check for the presence of the cloud environment variable:
```bash
if [ "$CODESPACES" = "true" ]

```

* **If True (GitHub Codespaces):** The container will globally rewrite SSH URLs to HTTPS using Git's native runtime translation (`git config --global url."https://github./".insteadOf "git@github.com:"`). This forces Git to use the browser's expanded **GitHub Trusted Repositories** OAuth token.
* **If False (Local Workstation):** The container will bypass the rewrite, allowing Git commands to natively pass through to the forwarded local `ssh-agent` socket.

## Consequences

### Positive

* **Absolute Portability:** The exact same container image and repository state can be opened locally or via a web browser on any machine without configuration drift.
* **Zero Code Pollution:** No environment-specific hacks or temporary URL changes need to be committed to Git.
* **Native Security:** Capitalizes on existing platform-native security mechanics (`ssh-agent` locally, OAuth tokens in the cloud).

### Negative / Risks

* **Implicit Dependency:** Relies on developer account-level maintenance to ensure that required private submodule repositories are explicitly checked under "Trusted Repositories" in their global GitHub Codespaces settings.
* **Debugging Complexity:** If a submodule fails to pull in the cloud, developers must remember that runtime URL translation is occurring behind the scenes.

---

## Attribution & Provenance

* **Collaborator / Model:** Gemini (Large Language Model)
* **Date:** July 2026

