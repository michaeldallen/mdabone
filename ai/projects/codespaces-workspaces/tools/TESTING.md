# Converter Tool Testing

This repository includes a pytest suite for the converter script:

- Script under test: `ai/projects/codespaces-workspaces/tools/jsonc_to_codespaces_repos.py`
- Tests: `ai/projects/codespaces-workspaces/tools/tests/test_jsonc_to_codespaces_repos.py`
- Test runner target: top-level `Makefile`

## Run Tests

From repository root:

```bash
make venv
source .venv/bin/activate
make test
```

`make venv` creates `.venv` if missing and installs/updates `pytest`.

If you prefer a different virtualenv folder name:

```bash
make venv VENV_DIR=venv
source venv/bin/activate
make test
```

Or run only converter tests directly:

```bash
python3 -m pytest -q ai/projects/codespaces-workspaces/tools/tests
```

## Add New/Custom Tests

1. Open `ai/projects/codespaces-workspaces/tools/tests/test_jsonc_to_codespaces_repos.py`.
2. Add a new `test_*` function.
3. Use `tmp_path` to create temporary JSONC inputs.
4. Call the helper `run_tool(config_path, *args)` to execute the converter as a CLI.
5. Assert both `returncode` and output/error text.

Pattern to copy:

```python
def test_my_custom_case(tmp_path: Path) -> None:
    config = tmp_path / "case.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 1,
          "owners": [
            {
              "owner": "my-owner",
              "repos": [{ "repo": "my-repo" }]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode == 0, result.stderr
```

## Suggested Custom Scenarios

- Multiple owners with overlapping permission keys.
- `--allowed-permission-values` custom list.
- `--mode customizations` JSON shape validation.
- Empty owners/repos arrays.
- Invalid data types (non-string repo/owner names).

## Makefile Customization

You can override test path and Python executable:

```bash
make test PYTHON=python3.14
make test CONVERTER_TEST_PATH=ai/projects/codespaces-workspaces/tools/tests
```
