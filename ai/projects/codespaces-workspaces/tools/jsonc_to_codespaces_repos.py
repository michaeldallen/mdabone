#!/usr/bin/env python3
"""Convert a JSONC multi-owner repo config into a Codespaces repositories stanza.

Input format (JSONC):
{
    "schemaVersion": 1,
  "permissions": { ... },
  "owners": [
    {
      "owner": "owner-name",
      "permissions": { ... },
      "repos": [
        { "repo": "repo-name", "permissions": { ... } }
      ]
    }
  ]
}

Output format (JSON):
{
  "repositories": {
    "owner/repo": {
      "permissions": { ... }
    }
  }
}
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


SUPPORTED_SCHEMA_VERSIONS = {1}


def _strip_jsonc(text: str) -> str:
    """Remove JSONC comments while preserving string literals."""
    out: list[str] = []
    i = 0
    in_string = False
    escaped = False

    while i < len(text):
        ch = text[i]

        if in_string:
            out.append(ch)
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                in_string = False
            i += 1
            continue

        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue

        if ch == "/" and i + 1 < len(text):
            nxt = text[i + 1]
            if nxt == "/":
                i += 2
                while i < len(text) and text[i] not in "\r\n":
                    i += 1
                continue
            if nxt == "*":
                i += 2
                while i + 1 < len(text) and not (text[i] == "*" and text[i + 1] == "/"):
                    i += 1
                i += 2
                continue

        out.append(ch)
        i += 1

    return "".join(out)


def _remove_trailing_commas(text: str) -> str:
    """Remove trailing commas in objects/arrays after comment stripping."""
    prev = None
    cur = text
    pattern = re.compile(r",(\s*[}\]])")
    while prev != cur:
        prev = cur
        cur = pattern.sub(r"\1", cur)
    return cur


def parse_jsonc(path: Path) -> dict[str, Any]:
    raw = path.read_text(encoding="utf-8")
    cleaned = _remove_trailing_commas(_strip_jsonc(raw))
    try:
        parsed = json.loads(cleaned)
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Failed to parse JSONC from {path}: {exc}") from exc

    if not isinstance(parsed, dict):
        raise SystemExit("Input must be a JSON object at top level.")

    return parsed


def _permissions_dict(
    value: Any,
    where: str,
    *,
    strict_permissions: bool,
    allowed_permission_values: set[str],
) -> dict[str, str]:
    if value is None:
        return {}
    if not isinstance(value, dict):
        raise SystemExit(f"{where} permissions must be an object.")

    normalized: dict[str, str] = {}
    for key, v in value.items():
        if not isinstance(key, str) or not isinstance(v, str):
            raise SystemExit(f"{where} permissions must map string keys to string values.")
        if strict_permissions and v not in allowed_permission_values:
            allowed = ", ".join(sorted(allowed_permission_values))
            raise SystemExit(
                f'{where} permission "{key}" has invalid value "{v}". '
                f"Allowed values: {allowed}."
            )
        normalized[key] = v
    return normalized


def get_schema_version(config: dict[str, Any]) -> int:
    raw = config.get("schemaVersion", 1)
    if isinstance(raw, int):
        version = raw
    elif isinstance(raw, str) and raw.isdigit():
        version = int(raw)
    else:
        raise SystemExit(
            '"schemaVersion" must be an integer (or numeric string), for example: 1.'
        )

    if version not in SUPPORTED_SCHEMA_VERSIONS:
        supported = ", ".join(str(v) for v in sorted(SUPPORTED_SCHEMA_VERSIONS))
        raise SystemExit(
            f'Unsupported schemaVersion "{version}". Supported versions: {supported}.'
        )

    return version


def build_repositories(
    config: dict[str, Any],
    *,
    strict_permissions: bool,
    allowed_permission_values: set[str],
    on_duplicate: str = "fail",
) -> dict[str, dict[str, dict[str, str]]]:
    global_perms = _permissions_dict(
        config.get("permissions"),
        "global",
        strict_permissions=strict_permissions,
        allowed_permission_values=allowed_permission_values,
    )
    owners = config.get("owners", [])

    if owners is None:
        owners = []
    if not isinstance(owners, list):
        raise SystemExit('"owners" must be an array when provided.')

    repositories: dict[str, dict[str, dict[str, str]]] = {}

    for owner_item in owners:
        if not isinstance(owner_item, dict):
            raise SystemExit("Each owner entry must be an object.")

        owner_name = owner_item.get("owner")
        if not isinstance(owner_name, str) or not owner_name.strip():
            raise SystemExit('Each owner entry must include a non-empty string "owner".')

        owner_perms = _permissions_dict(
            owner_item.get("permissions"),
            f'owner "{owner_name}"',
            strict_permissions=strict_permissions,
            allowed_permission_values=allowed_permission_values,
        )
        repos = owner_item.get("repos", [])

        if repos is None:
            repos = []
        if not isinstance(repos, list):
            raise SystemExit(f'Owner "{owner_name}" field "repos" must be an array.')

        for repo_item in repos:
            if not isinstance(repo_item, dict):
                raise SystemExit(f'Each repo entry for owner "{owner_name}" must be an object.')

            repo_name = repo_item.get("repo")
            if not isinstance(repo_name, str) or not repo_name.strip():
                raise SystemExit(
                    f'Each repo entry for owner "{owner_name}" must include a non-empty string "repo".'
                )

            repo_perms = _permissions_dict(
                repo_item.get("permissions"),
                f'repo "{owner_name}/{repo_name}"',
                strict_permissions=strict_permissions,
                allowed_permission_values=allowed_permission_values,
            )

            effective_perms = {}
            effective_perms.update(global_perms)
            effective_perms.update(owner_perms)
            effective_perms.update(repo_perms)

            repo_key = f"{owner_name}/{repo_name}"
            if repo_key in repositories and on_duplicate == "fail":
                raise SystemExit(
                    f'Duplicate repository entry found for "{repo_key}". '
                    "Use --on-duplicate last-wins to allow overriding."
                )
            repositories[repo_key] = {"permissions": effective_perms}

    return repositories


def _fragment_repositories_block(repositories: dict[str, Any], indent: int = 2) -> str:
    payload = json.dumps(repositories, indent=indent, sort_keys=True)
    ind = " " * indent
    payload_lines = payload.splitlines()
    if len(payload_lines) == 1:
        return f'"repositories": {payload_lines[0]}'

    body = "\n".join(f"{ind}{line}" for line in payload_lines)
    return f'"repositories": {body.lstrip()}'


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        description="Convert JSONC multi-owner config to a Codespaces repositories stanza."
    )
    parser.add_argument("input", type=Path, help="Path to JSONC input file")
    parser.add_argument(
        "--mode",
        choices=["codespaces", "customizations", "fragment"],
        default="codespaces",
        help=(
            "Output shape: codespaces => {\"repositories\": ...}; "
            "customizations => {\"customizations\": {\"codespaces\": {\"repositories\": ...}}}; "
            "fragment => bare \"repositories\": ... stanza"
        ),
    )
    parser.add_argument("--indent", type=int, default=2, help="JSON indentation size")
    parser.add_argument(
        "--on-duplicate",
        choices=["fail", "last-wins"],
        default="fail",
        help=(
            "How to handle duplicate owner/repo entries. "
            "fail => exit with an error; last-wins => later entry overrides earlier entry."
        ),
    )
    parser.add_argument(
        "--strict-permissions",
        action=argparse.BooleanOptionalAction,
        default=True,
        help=(
            "Validate permission values against allowed values list. "
            "Use --no-strict-permissions to disable."
        ),
    )
    parser.add_argument(
        "--allowed-permission-values",
        default="read,write,none",
        help=(
            "Comma-separated allowed permission values used when strict permission validation is enabled."
        ),
    )
    args = parser.parse_args(argv)

    config = parse_jsonc(args.input)
    get_schema_version(config)

    allowed_permission_values = {
        item.strip()
        for item in args.allowed_permission_values.split(",")
        if item.strip()
    }
    if args.strict_permissions and not allowed_permission_values:
        raise SystemExit(
            "--allowed-permission-values must contain at least one value when strict validation is enabled."
        )

    repositories = build_repositories(
        config,
        strict_permissions=args.strict_permissions,
        allowed_permission_values=allowed_permission_values,
        on_duplicate=args.on_duplicate,
    )

    if args.mode == "fragment":
        print(_fragment_repositories_block(repositories, indent=args.indent))
        return 0

    if args.mode == "codespaces":
        output: dict[str, Any] = {"repositories": repositories}
    else:
        output = {"customizations": {"codespaces": {"repositories": repositories}}}

    print(json.dumps(output, indent=args.indent, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
