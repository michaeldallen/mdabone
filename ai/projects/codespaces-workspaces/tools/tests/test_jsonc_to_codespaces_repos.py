from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / "jsonc_to_codespaces_repos.py"


def run_tool(config_path: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(config_path), *args],
        check=False,
        text=True,
        capture_output=True,
    )


def write_file(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8")


def test_valid_jsonc_inheritance_and_fragment_output(tmp_path: Path) -> None:
    config = tmp_path / "repos.jsonc"
    write_file(
        config,
        """
        {
          // Global defaults
          "schemaVersion": 1,
          "permissions": { "contents": "read", },
          "owners": [
            {
              "owner": "michaeldallen",
              "permissions": { "contents": "write" },
              "repos": [
                {
                  "repo": "mdabone",
                  "permissions": {
                    "pull-requests": "write"
                  }
                },
              ]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config, "--mode", "codespaces")

    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert "repositories" in payload
    assert payload["repositories"]["michaeldallen/mdabone"]["permissions"] == {
        "contents": "write",
        "pull-requests": "write",
    }


def test_duplicate_repo_fails_by_default(tmp_path: Path) -> None:
    config = tmp_path / "dup.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 1,
          "owners": [
            {
              "owner": "michaeldallen",
              "repos": [
                { "repo": "mdabone" },
                { "repo": "mdabone" }
              ]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode != 0
    assert "Duplicate repository entry found" in result.stderr


def test_duplicate_repo_last_wins(tmp_path: Path) -> None:
    config = tmp_path / "dup-last-wins.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 1,
          "owners": [
            {
              "owner": "michaeldallen",
              "repos": [
                { "repo": "mdabone", "permissions": { "contents": "read" } },
                { "repo": "mdabone", "permissions": { "contents": "write" } }
              ]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config, "--on-duplicate", "last-wins")

    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert payload["repositories"]["michaeldallen/mdabone"]["permissions"]["contents"] == "write"


def test_invalid_permission_value_fails_with_strict_default(tmp_path: Path) -> None:
    config = tmp_path / "invalid-perm.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 1,
          "owners": [
            {
              "owner": "michaeldallen",
              "repos": [
                { "repo": "mdabone", "permissions": { "contents": "admin" } }
              ]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode != 0
    assert "invalid value \"admin\"" in result.stderr


def test_invalid_permission_value_can_pass_when_strict_is_disabled(tmp_path: Path) -> None:
    config = tmp_path / "invalid-perm-allowed.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 1,
          "owners": [
            {
              "owner": "michaeldallen",
              "repos": [
                { "repo": "mdabone", "permissions": { "contents": "admin" } }
              ]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config, "--no-strict-permissions")

    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert payload["repositories"]["michaeldallen/mdabone"]["permissions"]["contents"] == "admin"


def test_schema_version_unsupported_fails(tmp_path: Path) -> None:
    config = tmp_path / "schema-bad.jsonc"
    write_file(
        config,
        """
        {
          "schemaVersion": 2,
          "owners": []
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode != 0
    assert "Unsupported schemaVersion" in result.stderr


def test_schema_version_defaults_to_1_when_omitted(tmp_path: Path) -> None:
    config = tmp_path / "schema-default.jsonc"
    write_file(
        config,
        """
        {
          "owners": [
            {
              "owner": "michaeldallen",
              "repos": [{ "repo": "mdabone" }]
            }
          ]
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert "michaeldallen/mdabone" in payload["repositories"]


def test_legacy_workspace_config_shape_is_supported(tmp_path: Path) -> None:
    config = tmp_path / "workspace-config.json"
    write_file(
        config,
        """
        {
          "owner": "michaeldallen",
          "default_permissions": { "contents": "write" },
          "repositories": [
            "mda",
            { "name": "libmose" },
            { "name": "3d", "permissions": { "contents": "read" } }
          ]
        }
        """.strip(),
    )

    result = run_tool(config)

    assert result.returncode == 0, result.stderr
    payload = json.loads(result.stdout)
    assert payload["repositories"]["michaeldallen/mda"]["permissions"] == {
        "contents": "write"
    }
    assert payload["repositories"]["michaeldallen/libmose"]["permissions"] == {
        "contents": "write"
    }
    assert payload["repositories"]["michaeldallen/3d"]["permissions"] == {
        "contents": "read"
    }
