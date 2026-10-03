include repos.mk

.DEFAULT_GOAL := help
.PHONY: help list status

help: ## Show available targets
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | sed -E 's/:.*## /\t/'

list: ## List managed repos and their paths
	@for r in $(REPOS); do echo "$$r\t$(WORKSPACES_DIR)/$$r"; done

status: ## Show branch, upstream divergence, and working-tree status for each repo
	@failed=0; \
	for r in $(REPOS); do \
		path="$(WORKSPACES_DIR)/$$r"; \
		printf '== %s ==\n' "$$r"; \
		if [ ! -d "$$path" ]; then \
			printf 'ERROR: repository directory not found: %s\n' "$$path" >&2; \
			failed=1; \
		elif ! git -C "$$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then \
			printf 'ERROR: not a Git repository: %s\n' "$$path" >&2; \
			failed=1; \
		elif ! git -C "$$path" status --short --branch; then \
			failed=1; \
		fi; \
	done; \
	exit "$$failed"
