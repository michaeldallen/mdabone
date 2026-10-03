# mrwc

Makefile-driven management of the non-hub repositories in the multi-repository workspace (MRWC = multi-repo workspace config/control; hub = `mdabone`).

This project is also a vehicle for learning to work with Copilot. All context lives in git, not in session history.

## Resuming work

1. Read this file, [docs/backlog.md](docs/backlog.md) and [docs/decisions.md](docs/decisions.md).
2. Use [prompts/context.md](prompts/context.md) as the standing context for a new session.
3. Commit small, one logical change per commit, and update the backlog in the same commit.

## Layout

| Path | Purpose |
|------|---------|
| `Makefile` | The deliverable. Run `make help`. |
| `repos.mk` | The list of managed non-hub repos and their location. |
| `docs/decisions.md` | Why choices were made. |
| `docs/backlog.md` | Next steps. |
| `prompts/context.md` | Standing context for Copilot sessions. |

## Usage

```bash
cd ai/projects/mrwc
make help
make list
make status
```

## Independence

This project is self-contained in this directory and does not depend on other projects in the hub (it intentionally ignores `ai/projects/codespaces-workspaces`).
