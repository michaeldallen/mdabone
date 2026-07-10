.PHONY: \
	git.submodule.diff.log \
	git.submodule.diff.short \
	git.submodule.diff.summary \
	git.submodule.diff.uncommitted \
	git.submodule.init

git.submodule.init:
	git submodule update --init --recursive

git.submodule.diff.short:
	git diff --submodule=short

git.submodule.diff.log:
	git diff --submodule=log

git.submodule.diff.summary:
	git submodule summary --recursive

git.submodule.diff.uncommitted:
	git submodule foreach --recursive 'echo "=== $$name ==="; git status --short; git diff'
