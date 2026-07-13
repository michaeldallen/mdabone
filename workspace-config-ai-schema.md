# AI Generation Schema for workspace-config.json

Use this document as the instruction contract for any AI that needs to generate `workspace-config.json` for this repository.

## Goal

Generate a JSONC config file in the exact shape expected by `workspace-configurator`.

## Required Output Format

Return only a single JSONC object with these top-level keys:

1. `owner` (string)
2. `default_permissions` (object of string->string)
3. `repositories` (array)

`repositories` entries can be:

1. A string repo name, for default permissions.
2. An object with:
   - `name` (string)
   - `permissions` (object of string->string, optional)

## Canonical Schema (JSON Schema)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "workspace-config.json",
  "type": "object",
  "required": ["owner", "default_permissions", "repositories"],
  "additionalProperties": false,
  "properties": {
    "owner": {
      "type": "string",
      "minLength": 1
    },
    "default_permissions": {
      "type": "object",
      "additionalProperties": {
        "type": "string"
      }
    },
    "repositories": {
      "type": "array",
      "items": {
        "oneOf": [
          {
            "type": "string",
            "minLength": 1
          },
          {
            "type": "object",
            "required": ["name"],
            "additionalProperties": false,
            "properties": {
              "name": {
                "type": "string",
                "minLength": 1
              },
              "permissions": {
                "type": "object",
                "additionalProperties": {
                  "type": "string"
                }
              }
            }
          }
        ]
      }
    }
  }
}
```

## Prompt You Can Give an AI

Generate `workspace-config.json` as JSONC using this exact schema:

- `owner`: string
- `default_permissions`: object of permission name to permission value
- `repositories`: array of repo names (string) or objects `{ "name": "repo", "permissions": { ... } }`

Constraints:

1. Use owner `michaeldallen`.
2. Use default permissions `{ "contents": "write" }`.
3. Include exactly these repos in `repositories`: `mda`, `libmose`, `3d`.
4. Use string entries for the repos (do not use object form unless a repo needs an override).
5. Output only the JSONC content, no explanation.

## Expected Output for This Request

```jsonc
{
  // The owner (GitHub username or organization) of the repositories
  "owner": "michaeldallen",

  // Default permissions applied to repositories unless overridden
  "default_permissions": {
    "contents": "write"
  },

  // List of repositories to configure and clone
  "repositories": [
    "mda",
    "libmose",
    "3d"
  ]
}
```