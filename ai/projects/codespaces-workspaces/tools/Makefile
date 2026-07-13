PYTHON ?= python3
PYTEST ?= $(PYTHON) -m pytest
CONVERTER_TEST_PATH ?= tests
VENV_DIR ?= venv.pytest
VENV_PYTHON := $(VENV_DIR)/bin/python

.PHONY: venv test test-converter

venv:
	@test -x "$(VENV_PYTHON)" || $(PYTHON) -m venv "$(VENV_DIR)"
	@"$(VENV_PYTHON)" -m pip install --upgrade pip pytest

test: test-converter

test-converter:
	$(PYTEST) -q $(CONVERTER_TEST_PATH)
